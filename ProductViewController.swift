//
//  ProductViewController.swift
//  Mist
//
//  Created by Steven on 6/15/16.
//
//

import UIKit
import Stripe
import AWSMobileHubHelper

class ProductViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .whiteColor()
        setViewConstraints()
    }
    
    // MARK: - Model
    
    var product: Feed.Item? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            buyButton.setTitle("Buy for \(product!.price)", forState: .Normal)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Buy item", forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: #selector(ProductViewController.purchaseItem), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(button)
        return button
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
        buyButton.centerInSuperview()
    }
    
    // MARK: - Payment
    
    func purchaseItem() {
        
        AnalyticsManager.sharedInstance.recordEvent(Event.Product.BuyPressed)
        
        guard product != nil else {
            print("Error <ProductViewController>: product was nil")
            return
        }
        
        do {
            let request: PKPaymentRequest? = try PaymentManager.sharedInstance.generatePaymentRequest(product!)
            
            guard request != nil else {
                print("Device does not support apple pay")
                
                // TODO: Show credit card entry form here
                return
            }
            
            let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: request!)
            paymentViewController.delegate = self
            presentViewController(paymentViewController, animated: true, completion: nil)
            
        } catch {
            print("PaymentManager error: \(error)")
            return
        }
    }
    
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        currentPayment = payment
        handlePaymentAuthorizationWithPayment(payment, completion: completion)
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        currentPayment = nil
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handlePaymentAuthorizationWithPayment(payment: PKPayment, completion: PKPaymentAuthorizationStatus -> ()) {
        STPAPIClient.sharedClient().createTokenWithPayment(payment) { (token, error) -> Void in
            guard error == nil else {
                completion(.Failure)
                return
            }
            
            self.createBackendChargeWithToken(token!, completion: completion)
        }
    }
    
    internal func createBackendChargeWithToken(token: STPToken, completion: (PKPaymentAuthorizationStatus) -> Void) {
        let functionName = "purchaseItem"
        let parameters = getPurchaseParameters(token.tokenId)!
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction(functionName, withParameters: parameters) { (result: AnyObject?, error: NSError?) in
            dispatch_async(dispatch_get_main_queue()) {
                guard error == nil else {
                    completion(.Failure)
                    return
                }
                
                completion(.Success)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     The current payment in progress. Used to send contact information to Stripe.
     */
    private var currentPayment: PKPayment? = nil
    
    /**
     Email address from the current PKPaymentRequest.
     */
    private var email: String? {
        get {
            if #available(iOS 9, *) {
                guard let shippingEmail = currentPayment?.shippingContact?.emailAddress else {
                    return nil
                }
                
                return shippingEmail
            } else {
                
                // TODO: Collect email through some other method
                return "test@mistshopping.com"
            }
        }
    }
    
    /**
     Generates the parameters to be used in the Stripe request.
     */
    func getPurchaseParameters(tokenId: String) -> [String : String]? {
        guard let item = product else {
            return nil
        }
        
        guard let priceInDollars = Double(item.price) else {
            return nil
        }
        
        guard email != nil else {
            return nil
        }
        
        return [
            "price": "\(Int(priceInDollars * 100))",
            "token": tokenId,
            "email": email!
        ]
    }
}
