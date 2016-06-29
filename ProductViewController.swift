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
        let components: [UIView] = [productTitleLabel, byCompanyLabel, titleLine, productPriceLabel, descriptionLabel, imageViewScrollView, buyButton, shippingLine, packageIcon, shippingSublabel, shippingLabel, returnIcon, returnLabel, returnSubLabel]
        
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
            
            dispatch_async(dispatch_get_main_queue()) {
                self.setPriceText("$\(Int(Double(self.product!.price)!))")
                self.setTitleText(self.product!.name)
                self.setCompanyText(self.product!.brand)
                self.buyButton.price = Float(Double(self.product!.price)!)
            }
            
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
        scrollView.showsVerticalScrollIndicator = false
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
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var byCompanyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        self.scrollView.addSubview(label)
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
    
    private func setCompanyText(name: String) {
        let string = NSMutableAttributedString(string: "by \(name)")
        
        string.addAttribute(NSForegroundColorAttributeName, value: UIColor(white: 210/255.0, alpha: 1), range: NSMakeRange(0, string.length))
        
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Light", size: 13)!, range: NSMakeRange(0, "by ".length))
        
        string.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange("by ".length, name.characters.count))
        
        byCompanyLabel.attributedText = string
    }
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Right
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var titleLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 1.0, alpha: 0.21)
        self.scrollView.addSubview(line)
        return line
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
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = .whiteColor()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        
        self.view.addSubview(label)
        return label
    }()
    
    let moreImagesHeight: CGFloat = 160
    
    private lazy var imageViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.09)
        scrollView.alwaysBounceHorizontal = true
        scrollView.scrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(scrollView)
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
    
    private lazy var bottomBar: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var buyButton: BuyButton = {
        let button = BuyButton()
        button.backgroundColor = Constants.Colors.BuyBlue
        button.addTarget(self, action: #selector(purchaseItem), forControlEvents: .TouchUpInside)
        self.bottomBar.addSubview(button)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.layer.opacity = 0.6
        button.setImage(UIImage(named: "Products-Share"), forState: .Normal)
        self.bottomBar.addSubview(button)
        return button
    }()
    
    var liked = false
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.layer.opacity = 0.6
        button.setImage(UIImage(named: "Products-Heart"), forState: .Normal)
        button.addTarget(self, action: #selector(heartPressed), forControlEvents: .TouchUpInside)
        self.bottomBar.addSubview(button)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "Product-X"), forState: .Normal)
        button.addTarget(self, action: #selector(closeView), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(button)
        return button
    }()
    
    func heartPressed() {
        var newImageTitle: String
        
        if liked {
            newImageTitle = "Products-Heart"
        } else {
            newImageTitle = "Products-Heart-Filled"
        }
        
        likeButton.setImage(UIImage(named: newImageTitle), forState: .Normal)
        liked = !liked
    }
    
    private lazy var packageIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Product-Ship"))
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var shippingLabel: UILabel = {
        let label = UILabel()
        label.text = "Ships in 2 - 4 business days"
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = .whiteColor()
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var shippingSublabel: UILabel = {
        let label = UILabel()
        label.text = "Arrives July 1 - 2"
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(white: 1.0, alpha: 0.42)
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var shippingLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 1.0, alpha: 0.21)
        self.scrollView.addSubview(line)
        return line
    }()
    
    private lazy var returnIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Product-Cart"))
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var returnLabel: UILabel = {
        let label = UILabel()
        label.text = "Return free for 14 days"
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = .whiteColor()
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var returnSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Before July 11"
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(white: 1.0, alpha: 0.42)
        self.scrollView.addSubview(label)
        return label
    }()
    
    private var sizeLabel: UILabel? = nil
    
    private lazy var sizeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.18, alpha: 1)
        
        let icon = UIImageView(image: UIImage(named: "Product-Shirt"))
        button.addSubview(icon)
        icon.centerVerticallyInSuperview()
        icon.pinToLeftEdgeOfSuperview(offset: 10)
        icon.sizeToWidth(26)
        icon.sizeToHeight(25)
        
        self.sizeLabel = UILabel()
        self.sizeLabel!.text = "Select a size"
        self.sizeLabel!.textColor = .whiteColor()
        self.sizeLabel!.font = UIFont(name: "Lato-Bold", size: 14)
        button.addSubview(self.sizeLabel!)
        self.sizeLabel!.centerVerticallyInSuperview()
        self.sizeLabel!.positionToTheRightOfItem(icon, offset: 20)
        
        let dropdown = UIImageView(image: UIImage(named: "Product-Size-Dropdown"))
        button.addSubview(dropdown)
        dropdown.centerVerticallyInSuperview()
        dropdown.pinToRightEdgeOfSuperview(offset: 10)
        dropdown.sizeToWidth(19)
        dropdown.sizeToHeight(11)
        
        button.addTarget(self, action: #selector(sizeButtonPressed), forControlEvents: .TouchUpInside)
        
        self.scrollView.addSubview(button)
        return button
    }()
    
    internal func sizeButtonPressed() {
        let alert = UIAlertController(title: "Choose size", message: "Please select a size", preferredStyle: .ActionSheet)
        
        let completion = { (size: String) in
            dispatch_async(dispatch_get_main_queue()) {
                self.sizeLabel?.text = size
            }
        }
        
        for size in ["Small", "Medium", "Large"] {
            alert.addAction(UIAlertAction(title: size, style: .Default) { (UIAlertAction) in
                completion(size)
                })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    } 
    
    // MARK: - Layout
    
    private var imageTopConstraint: NSLayoutConstraint? = nil
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    private var imageWidthConstraint: NSLayoutConstraint? = nil
    private var closeButtonTopConstraint: NSLayoutConstraint? = nil
    
    func setViewConstraints() {
        
        // Top image view
        
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
        
        releaseLabel.centerHorizontallyInSuperview()
        releaseLabel.pinToTopEdgeOfSuperview(offset: 10)
        
        closeButton.sizeToWidthAndHeight(20)
        closeButton.pinToLeftEdgeOfSuperview(offset: 15)
        closeButtonTopConstraint = closeButton.pinToTopEdgeOfSuperview(offset: 15)
        
        // Title
        
        titleLine.sizeToHeight(1)
        titleLine.sizeToWidth(self.view.frame.width - 20)
        titleLine.pinToLeftEdgeOfSuperview(offset: 10)
        titleLine.positionBelowItem(mainImageView, offset: 20)
        
        byCompanyLabel.pinToLeftEdgeOfSuperview(offset: 10)
        byCompanyLabel.positionAboveItem(titleLine, offset: 12)
        
        productPriceLabel.pinToLeftEdgeOfSuperview()
        productPriceLabel.sizeToWidth(self.view.frame.width - 10)
        productPriceLabel.positionAboveItem(titleLine, offset: 12)
        
        productTitleLabel.pinToLeftEdgeOfSuperview(offset: 10)
        productTitleLabel.positionAboveItem(byCompanyLabel, offset: 2)
        
        // Description
        
        descriptionLabel.positionBelowItem(titleLine, offset: 20)
        descriptionLabel.pinToSideEdgesOfSuperview(offset: 10)
        
        imageViewScrollView.positionBelowItem(descriptionLabel, offset: 25)
        imageViewScrollView.pinToLeftEdgeOfSuperview()
        imageViewScrollView.sizeToWidth(self.view.frame.width)
        imageViewScrollView.sizeToHeight(160)
        
        // Shipping and return information
        
        packageIcon.pinToLeftEdgeOfSuperview(offset: 10)
        packageIcon.positionBelowItem(imageViewScrollView, offset: 30)
        packageIcon.sizeToWidth(26)
        packageIcon.sizeToHeight(29)
        
        shippingLabel.pinTopEdgeToTopEdgeOfItem(packageIcon)
        shippingLabel.positionToTheRightOfItem(packageIcon, offset: 20)
        
        shippingSublabel.positionBelowItem(shippingLabel, offset: 1)
        shippingSublabel.positionToTheRightOfItem(packageIcon, offset: 20)
        
        shippingLine.pinLeftEdgeToLeftEdgeOfItem(shippingLabel)
        shippingLine.sizeToWidth(self.view.frame.width)
        shippingLine.sizeToHeight(1)
        shippingLine.positionBelowItem(shippingSublabel, offset: 10)
        
        returnIcon.pinToLeftEdgeOfSuperview(offset: 10)
        returnIcon.positionBelowItem(shippingLine, offset: 10)
        returnIcon.sizeToWidth(26)
        returnIcon.sizeToHeight(28)
        
        returnLabel.pinTopEdgeToTopEdgeOfItem(returnIcon)
        returnLabel.positionToTheRightOfItem(returnIcon, offset: 20)
        
        returnSubLabel.positionBelowItem(returnLabel, offset: 1)
        returnSubLabel.positionToTheRightOfItem(returnIcon, offset: 20)
        
        // Sizing
        
        sizeButton.positionBelowItem(returnSubLabel, offset: 20)
        sizeButton.pinToLeftEdgeOfSuperview()
        sizeButton.sizeToWidth(self.view.frame.width)
        sizeButton.sizeToHeight(58)
        
        // Bottom Bar
        
        buyButton.pinToTopAndBottomEdgesOfSuperview()
        buyButton.pinToRightEdgeOfSuperview()
        buyButton.sizeToWidth(150)
        
        bottomBar.pinToBottomEdgeOfSuperview()
        bottomBar.pinToSideEdgesOfSuperview()
        bottomBar.sizeToHeight(60)
        
        shareButton.pinToLeftEdgeOfSuperview(offset: 30)
        shareButton.sizeToHeight(25)
        shareButton.sizeToWidth(18)
        shareButton.centerVerticallyInSuperview(offset: -1)
        
        likeButton.positionToTheRightOfItem(shareButton, offset: 30)
        likeButton.sizeToWidthAndHeight(22)
        likeButton.centerVerticallyInSuperview()
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
        
        closeButtonTopConstraint?.constant = scrollView.contentOffset.y + 15
        
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
    
    internal func closeView() {
        let imageFrame = mainImageView.frame
        
        self.delegate?.transitionToCell(fromImageFrame: imageFrame) {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= scrollReleaseThreshold {
            closeView()
        }
    }
}
