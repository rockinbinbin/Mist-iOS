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

class ProductViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, UIScrollViewDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .blackColor()
        setViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        animateInComponents()
    }
    
    // MARK: - Animation
    
    func animateInComponents() {
        let components: [UIView] = [productTitleLabel, productPriceLabel, descriptionLabel, moreLabel, imageViewScrollView, buyButton]
        
        for component in components {
            component.layer.opacity = 0
        }
        
        UIView.animateWithDuration(0.25) {
            for component in components {
                component.layer.opacity = 1
            }
        }
    }
    
    // MARK: - Model
    
    var product: Feed.Item? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            buyButton.setTitle("Buy for \(product!.price)", forState: .Normal)
            setTitleText(product!.name)
            setPriceText("$\(Int(Double(product!.price)!))")
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    var imageHeight: CGFloat = 200
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {
                return
            }
            
            mainImageView.image = image
            imageHeight = (image.size.height / image.size.width) * self.view.frame.size.width
            imageHeightConstraint?.constant = imageHeight
            
            for _ in 0...3 {
                addImageToScrollView(image)
            }
        }
    }
    
    var delegate: FeedProductTransitionDelegate? = nil
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .blackColor()
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height * 1.5)
        scrollView.scrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var gradientView: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRectMake(0.0, 0.0, 1000, 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, atIndex: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.scrollView.addSubview(_blackGradientOverlay)
        
        return _blackGradientOverlay
    }()
    
    private lazy var topGradientView: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRectMake(0.0, 0.0, 1000, 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, atIndex: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.mainImageView.addSubview(_blackGradientOverlay)
        
        _blackGradientOverlay.layer.opacity = 0
        
        return _blackGradientOverlay
    }()
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        self.gradientView.addSubview(label)
        return label
    }()
    
    private func setTitleText(name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Regular", size: 18)!,
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercaseString, attributes: attributes as? [String : AnyObject])
        
        productTitleLabel.attributedText = attributedTitle
        productTitleLabel.sizeToFit()
    }
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        self.gradientView.addSubview(label)
        return label
    }()
    
    private func setPriceText(name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Light", size: 18)!,
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercaseString, attributes: attributes as? [String : AnyObject])
        
        productPriceLabel.attributedText = attributedTitle
        productPriceLabel.sizeToFit()
    }
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = .whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var moreLabel: UILabel = {
        let label = UILabel()
        
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 16)!,
            NSForegroundColorAttributeName:UIColor(white: 1.0, alpha: 0.8),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: "MORE OF THIS ITEM", attributes: attributes as? [String : AnyObject])
        
        label.attributedText = attributedTitle
        label.sizeToFit()
        
        self.view.addSubview(label)
        return label
    }()
    
    let moreImagesHeight: CGFloat = 160
    
    private lazy var imageViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
        scrollView.alwaysBounceHorizontal = true
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    var moreImages: [UIImageView] = []
    
    private func addImageToScrollView(image: UIImage) {
        
        let imageView = UIImageView(image: image)
        self.imageViewScrollView.addSubview(imageView)
        
        imageView.sizeToHeight(moreImagesHeight - 20)
        imageView.centerVerticallyInSuperview()
        
        let imageWidth = (image.size.width / image.size.height) * (moreImagesHeight - 20)
        imageView.sizeToWidth(imageWidth)
        
        if moreImages.count == 0 {
            imageView.pinToLeftEdgeOfSuperview(offset: 10)
        } else {
            imageView.positionToTheRightOfItem(moreImages[moreImages.count - 1], offset: 15)
        }
        
        moreImages.append(imageView)
        
        imageViewScrollView.contentSize = CGSizeMake(imageViewScrollView.contentSize.width + imageWidth + 20, moreImagesHeight)
    }
    
    private lazy var bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var buyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Buy item", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(ProductViewController.purchaseItem), forControlEvents: .TouchUpInside)
        
        self.bottomBar.addSubview(button)
        return button
    }()
    
    // MARK: - Layout
    
    private var imageTopConstraint: NSLayoutConstraint? = nil
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    private var imageWidthConstraint: NSLayoutConstraint? = nil
    
    func setViewConstraints() {
        
        scrollView.pinToLeftEdgeOfSuperview()
        scrollView.pinToTopEdgeOfSuperview()
        scrollView.sizeToWidth(self.view.frame.width)
        scrollView.sizeToHeight(self.view.frame.height)
        
        mainImageView.centerHorizontallyInSuperview()
        
        imageTopConstraint = mainImageView.pinToTopEdgeOfSuperview()
        imageHeightConstraint = mainImageView.sizeToHeight(imageHeight)
        imageWidthConstraint = mainImageView.sizeToWidth(self.view.frame.size.width)
        
        gradientView.sizeToHeight(75)
        gradientView.pinToLeftEdgeOfSuperview()
        gradientView.sizeToWidth(self.view.frame.width)
        gradientView.positionBelowItem(mainImageView, offset: -75)
        
        topGradientView.sizeToHeight(75)
        topGradientView.pinToTopEdgeOfSuperview()
        topGradientView.pinToSideEdgesOfSuperview()
        
        productTitleLabel.pinToLeftEdgeOfSuperview(offset: 10)
        productTitleLabel.pinToBottomEdgeOfSuperview(offset: 10)
        
        productPriceLabel.pinToRightEdgeOfSuperview(offset: 10)
        productPriceLabel.pinToBottomEdgeOfSuperview(offset: 10)
        
        releaseLabel.centerHorizontallyInSuperview()
        releaseLabel.pinToTopEdgeOfSuperview(offset: 10)
        
        descriptionLabel.positionBelowItem(mainImageView, offset: 25)
        descriptionLabel.pinToSideEdgesOfSuperview(offset: 10)
        
        moreLabel.positionBelowItem(descriptionLabel, offset: 25)
        moreLabel.pinToLeftEdgeOfSuperview(offset: 10)
        
        imageViewScrollView.positionBelowItem(moreLabel, offset: 15)
        imageViewScrollView.pinToSideEdgesOfSuperview()
        imageViewScrollView.sizeToHeight(160)
        
        buyButton.pinToRightEdgeOfSuperview(offset: 30)
        buyButton.centerVerticallyInSuperview()
        
        bottomBar.pinToBottomEdgeOfSuperview()
        bottomBar.pinToSideEdgesOfSuperview()
        bottomBar.sizeToHeight(60)
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
    
    // MARK: - Appearance
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Scrollview
    
    private lazy var releaseLabel: UILabel = {
        let label = UILabel()
        
        label.layer.opacity = 0
        
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor(white: 1.0, alpha: 0.7),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: "Release to return to feed".uppercaseString, attributes: attributes as? [String : AnyObject])
        
        label.attributedText = attributedTitle
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        return label
    }()
    
    var releaseLabelIsHidden = true
    
    private func showReleaseLabel() {
        guard releaseLabel.layer.opacity == 0 else {
            return
        }
        
        UIView.animateWithDuration(0.25) {
            self.releaseLabel.layer.opacity = 1
        }
    }
    
    private func hideReleaseLabel() {
        guard releaseLabel.layer.opacity != 0 else {
            return
        }
        
        UIView.animateWithDuration(0.25) {
            self.releaseLabel.layer.opacity = 0
        }
    }
    
    var scrollReleaseThreshold: CGFloat = -80
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y < 0 else {
            return
        }
        
        let y = scrollView.contentOffset.y
        
        imageTopConstraint?.constant = y
        let newImageHeight = imageHeight - y
        
        let percentDone: CGFloat = y / scrollReleaseThreshold
        
        topGradientView.layer.opacity = Float(percentDone > 1 ? 1 : percentDone) / 2
        
        imageHeightConstraint?.constant = newImageHeight
        imageWidthConstraint?.constant = newImageHeight * (mainImage!.size.width / mainImage!.size.height)
        
        if scrollView.contentOffset.y <= scrollReleaseThreshold && releaseLabelIsHidden {
            releaseLabelIsHidden = false
            showReleaseLabel()
        }
        
        else if scrollView.contentOffset.y > scrollReleaseThreshold && !releaseLabelIsHidden {
            releaseLabelIsHidden = true
            hideReleaseLabel()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= scrollReleaseThreshold {
            let imageFrame = mainImageView.frame
            
            self.delegate?.transitionToCell(fromImageFrame: imageFrame) {
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }
}
