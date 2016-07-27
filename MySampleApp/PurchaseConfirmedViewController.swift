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
        self.prefersStatusBarHidden()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        titleLabel.text = "Purchase Confirmed!"
        titleLabel.font = UIFont(name: "Lato-Regular", size: 24)
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
        
        returnButton.centerHorizontallyInSuperview()
        returnButton.pinToBottomEdgeOfSuperview()
        returnButton.sizeToHeight(62)
        returnButton.sizeToWidth(self.view.frame.size.width)
        
        self.view.addSubview(mainImageView)
        mainImageView.centerHorizontallyInSuperview()
        mainImageView.positionBelowItem(titleLabel, offset: 50)
        mainImageView.sizeToWidth(250)
        mainImageView.sizeToHeight(200)
        self.decorateImage(mainImageView)
        
        self.view.addSubview(checkView)
        checkView.positionToTheRightOfItem(mainImageView, offset: -38)
        checkView.positionAboveItem(mainImageView, offset: -38)
        
        self.view.addSubview(shipImageView)
        shipImageView.positionBelowItem(mainImageView, offset: 30)
        shipImageView.pinLeftEdgeToLeftEdgeOfItem(mainImageView)
        
        self.view.addSubview(cartImageView)
        cartImageView.positionBelowItem(shipImageView, offset: 15)
        cartImageView.pinLeftEdgeToLeftEdgeOfItem(mainImageView)
        
        self.view.addSubview(shareImageView)
        shareImageView.positionBelowItem(cartImageView, offset: 15)
        shareImageView.pinLeftEdgeToLeftEdgeOfItem(mainImageView)
    }
    
    internal func decorateImage(imageView: UIImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.whiteColor()
            decorateLabel.textAlignment = .Center
            decorateLabel.lineBreakMode = .ByWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: (self.product?.name)!)
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 10)!, range: NSMakeRange(0, attrString.length))
            
            decorateLabel.attributedText = attrString
            decorateLabel.font = UIFont(name: "Lato-Regular", size: 15)
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
            
            imageView?.layer.borderWidth = 0.5
            imageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
    }


    func returnToFeedPressed() {
        self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

}
