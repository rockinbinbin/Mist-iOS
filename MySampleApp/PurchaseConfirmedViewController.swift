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
        imageView.layer.cornerRadius = 0.5
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
        attrString.addAttribute(NSKernAttributeName, value: 4, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 18)!, range: NSMakeRange(0, attrString.length))
        
        returnButton.setAttributedTitle(attrString, forState: .Normal)
        self.view.addSubview(returnButton)
        
//        returnButton.addTarget(self, action: #selector(PurchaseConfirmedViewController.returntofeedPressed), forControlEvents: .TouchUpInside)
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
        returnButton.sizeToHeight(100)
        returnButton.sizeToWidth(self.view.frame.size.width)
        
        self.view.addSubview(mainImageView)
        mainImageView.centerHorizontallyInSuperview()
        mainImageView.positionBelowItem(titleLabel, offset: 50)
        mainImageView.sizeToWidth(200)
        mainImageView.sizeToHeight(200)
        mainImageView.contentMode = .ScaleAspectFill
    }

    func returnToFeedPressed() {
        
    }

}
