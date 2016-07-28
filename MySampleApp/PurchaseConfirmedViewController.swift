//
//  PurchaseConfirmedViewController.swift
//  Mist
//
//  Created by Robin Mehta on 7/26/16.
//
//

import UIKit

// grab product data from productviewcontroller

extension UIImageView{
    
    func makeBlurImage(targetImageView:UIImageView?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
    
}

class PurchaseConfirmedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.prefersStatusBarHidden() // not working. TODO: fix it
        setViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Model
    
    var product: Feed.Item? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
//                self.setPriceText("$\(Int(Double(self.product!.price)!))")
//                self.setTitleText(self.product!.name)
//                self.setCompanyText(self.product!.brand)
//                self.setDescriptionLabel(self.product!.description)
//                self.buyButton.price = Float(Double(self.product!.price)!)
//                self.viewBrandLabel?.text = "Browse more from \(self.product!.brand)"
            }
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    var imageHeight: CGFloat = 200
    private var imageHeightConstraint: NSLayoutConstraint? = nil
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clearColor()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var checkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "purchaseCheck")
        return imageView
    }()
    
    private lazy var shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Ship")
        return imageView
    }()
    
    private lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Cart")
        return imageView
    }()
    
    private lazy var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Share-Small")
        return imageView
    }()
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {
                return
            }
            
            mainImageView.image = image
            backgroundImageView.image = image
            imageHeight = (image.size.height / image.size.width) * self.view.frame.size.width
            imageHeightConstraint?.constant = imageHeight
        }
    }
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Forever grateful."
        titleLabel.font = UIFont(name: "Lato-Regular", size: 24)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var subtitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Look out for a package made with love ❤️"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shipLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Ships in 2 - 4 business days"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 10)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var returnLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Return free for 14 days"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 10)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shareLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Show & Tell! 🙈"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 14)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .Custom)
        shareButton.addTarget(self, action: #selector(PurchaseConfirmedViewController.shareProduct), forControlEvents: .TouchUpInside)
        return shareButton
    }()
    
    internal lazy var subShareLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "...for a chance to win Mist’s surprise box! ✨💫"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 12)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var returnButton: UIButton = {
        let returnButton = UIButton(type: .RoundedRect)
        returnButton.tintColor = UIColor.whiteColor()
        returnButton.backgroundColor = Constants.Colors.PrettyBlue
        
        let attrString = NSMutableAttributedString(string: "RETURN TO FEED")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 14)!, range: NSMakeRange(0, attrString.length))
        
        returnButton.setAttributedTitle(attrString, forState: .Normal)
        self.view.addSubview(returnButton)
        
        returnButton.addTarget(self, action: #selector(PurchaseConfirmedViewController.returnToFeedPressed), forControlEvents: .TouchUpInside)
        return returnButton
    }()

    func setViewConstraints() {
        backgroundImageView.centerHorizontallyInSuperview()
        backgroundImageView.sizeToWidth(self.view.frame.size.width)
        backgroundImageView.sizeToHeight(self.view.frame.size.height)
        backgroundImageView.contentMode = .ScaleAspectFill
        backgroundImageView.makeBlurImage(backgroundImageView)
        
        titleLabel.centerHorizontallyInSuperview()
        titleLabel.pinToTopEdgeOfSuperview(offset: 50)
        
        subtitleLabel.centerHorizontallyInSuperview()
        subtitleLabel.positionBelowItem(titleLabel, offset: 10)
        
        returnButton.centerHorizontallyInSuperview()
        returnButton.pinToBottomEdgeOfSuperview()
        returnButton.sizeToHeight(62)
        returnButton.sizeToWidth(self.view.frame.size.width)
        
        self.view.addSubview(mainImageView)
        mainImageView.centerHorizontallyInSuperview()
        mainImageView.positionBelowItem(subtitleLabel, offset: 35)
        mainImageView.sizeToWidth(250)
        mainImageView.sizeToHeight(200)
        self.decorateImage(mainImageView)
        
        self.view.addSubview(checkView)
        checkView.positionToTheRightOfItem(mainImageView, offset: -38)
        checkView.positionAboveItem(mainImageView, offset: -38)
        
        self.view.addSubview(shipImageView)
        shipImageView.positionBelowItem(mainImageView, offset: 20)
        shipImageView.pinLeftEdgeToLeftEdgeOfItem(mainImageView)
        
        shipLabel.pinTopEdgeToTopEdgeOfItem(shipImageView)
        shipLabel.positionToTheRightOfItem(shipImageView, offset: 20)
        
        self.view.addSubview(cartImageView)
        cartImageView.positionBelowItem(shipImageView, offset: 15)
        cartImageView.pinLeftEdgeToLeftEdgeOfItem(mainImageView)
        
        returnLabel.pinTopEdgeToTopEdgeOfItem(cartImageView)
        returnLabel.positionToTheRightOfItem(cartImageView, offset: 20)
        
        self.view.addSubview(shareButton)
        
        let shareView = UIView()
        
        shareButton.sizeToWidth(130)
        shareButton.sizeToHeight(50)
        shareButton.addSubview(shareView)
        
        shareButton.centerHorizontallyInSuperview()
        shareButton.positionAboveItem(returnButton, offset: 40)
        shareView.centerInSuperview()
        shareView.sizeToWidth(130)
        shareView.sizeToHeight(50)
        shareView.userInteractionEnabled = false
        
        shareView.addSubview(shareImageView)
        shareImageView.pinToLeftEdgeOfSuperview()
        shareImageView.centerVerticallyInSuperview()
        shareView.addSubview(shareLabel)
        shareLabel.positionToTheRightOfItem(shareImageView, offset: 10)
        shareLabel.centerVerticallyInSuperview()
        shareView.sizeToFit()
        
        subShareLabel.centerHorizontallyInSuperview()
        subShareLabel.positionBelowItem(shareView, offset: 5)
    }
    
    internal func decorateImage(imageView: UIImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.whiteColor()
            decorateLabel.textAlignment = .Center
            decorateLabel.lineBreakMode = .ByWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: (self.product?.name)!)
            attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 10)!, range: NSMakeRange(0, attrString.length))
            
            decorateLabel.attributedText = attrString
            decorateLabel.font = UIFont(name: "Lato-Regular", size: 10)
            self.view.addSubview(decorateLabel)
            return decorateLabel
        }()
        
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = Constants.Colors.DarkGray
            bottomView.layer.cornerRadius = 3
            return bottomView
        }()
        
        if (imageView?.image != nil) {
            imageView?.addSubview(bottomView)
            bottomView.pinToBottomEdgeOfSuperview()
            bottomView.pinToLeftEdgeOfSuperview()
            bottomView.pinToRightEdgeOfSuperview()
            bottomView.sizeToHeight(30)
            
            bottomView.addSubview(decorateLabel)
            decorateLabel.pinToLeftEdgeOfSuperview(offset: 10)
            decorateLabel.centerVerticallyInSuperview()
        }
    }

    func returnToFeedPressed() {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareProduct() {
        let name = (product?.name)!
        let companyName = (product?.brand)!
        
        // TODO: fix "xxx" to app store's link!
        let shareString = "\(name) by \(companyName) – curated by @MistMarked. Link: xxx"
        
        let activityViewController = UIActivityViewController(activityItems: [shareString as NSString, mainImage!], applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }

}
