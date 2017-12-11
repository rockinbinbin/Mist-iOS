//
//  PurchaseConfirmedViewController.swift
//  Mist
//
//  Created by Robin Mehta on 7/26/16.
//
//

import UIKit
import PureLayout

// grab product data from productviewcontroller

class PurchaseConfirmedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Model
    
    var product: Feed.Post? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            DispatchQueue.main.async {
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
    fileprivate var imageHeightConstraint: NSLayoutConstraint? = nil
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    fileprivate lazy var checkView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "purchaseCheck")
        return imageView
    }()
    
    fileprivate lazy var shipImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Ship")
        return imageView
    }()
    
    fileprivate lazy var cartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Cart")
        return imageView
    }()
    
    fileprivate lazy var shareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Product-Share-Small")
        return imageView
    }()
    
    fileprivate lazy var shortDividerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "line")
        return imageView
    }()
    
    fileprivate lazy var longDividerView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "longLine")
        return imageView
    }()
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {return}
            mainImageView.image = image
            backgroundImageView.image = image
            imageHeight = (image.size.height / image.size.width) * self.view.frame.size.width
            imageHeightConstraint?.constant = imageHeight
        }
    }
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleMediumWhiteLabel("Forever grateful.")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var subtitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleSmallWhiteLabel("Look out for a package made with love ❤️")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shipLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleSmallWhiteLabel("Ships in 2 - 4 business days")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var returnLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleSmallWhiteLabel("Return free for 14 days")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shareLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleSmallWhiteLabel("Show & Tell! 🙈")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .custom)
        shareButton.addTarget(self, action: #selector(PurchaseConfirmedViewController.shareProduct), for: .touchUpInside)
        return shareButton
    }()
    
    internal lazy var subShareLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.styleSmallWhiteLabel("...for a chance to win Mist’s surprise box! ✨💫")
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var returnButton: UIButton = {
        let returnButton = UIButton(type: .roundedRect)
        returnButton.tintColor = UIColor.white
        returnButton.backgroundColor = UIColor.PrettyBlue()
        let attrString = NSMutableAttributedString(string: "RETURN TO FEED")
        attrString.styleText("RETURN TO FEED")
        returnButton.setAttributedTitle(attrString, for: UIControlState())
        self.view.addSubview(returnButton)
        returnButton.addTarget(self, action: #selector(PurchaseConfirmedViewController.returnToFeedPressed), for: .touchUpInside)
        return returnButton
    }()

    func setViewConstraints() {
        backgroundImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        backgroundImageView.autoSetDimensions(to: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.makeBlurImage(backgroundImageView)

        titleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 50)

        subtitleLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        subtitleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)

        returnButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        returnButton.autoPinEdge(toSuperviewEdge: .bottom)
        returnButton.autoSetDimensions(to: CGSize(width: self.view.frame.size.width, height: 62))

        self.view.addSubview(mainImageView)

        mainImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        mainImageView.autoPinEdge(.top, to: .bottom, of: subtitleLabel, withOffset: 35)
        mainImageView.autoSetDimensions(to: CGSize(width: self.view.frame.size.width - 100, height: self.view.frame.size.width - 150))
        self.decorateImage(mainImageView)
        
        self.view.addSubview(checkView)

        checkView.autoPinEdge(.left, to: .right, of: mainImageView, withOffset: -38) // TODO: should be 38?
        checkView.autoPinEdge(.bottom, to: .top, of: mainImageView, withOffset: -38)
        
        self.view.addSubview(shipImageView)

        shipImageView.autoPinEdge(.top, to: .bottom, of: mainImageView, withOffset: 20)
        shipImageView.autoPinEdge(.left, to: .left, of: mainImageView)

        shipLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        shipLabel.autoPinEdge(.left, to: .right, of: shipImageView, withOffset: 20)
        
        self.view.addSubview(shortDividerView)

        shortDividerView.autoPinEdge(.top, to: .bottom, of: shipImageView)
        shortDividerView.autoPinEdge(.left, to: .left, of: shipLabel)

        self.view.addSubview(cartImageView)

        cartImageView.autoPinEdge(.top, to: .bottom, of: shipImageView, withOffset: 15)
        cartImageView.autoPinEdge(.left, to: .left, of: mainImageView)

        returnLabel.autoAlignAxis(.vertical, toSameAxisOf: cartImageView)
        returnLabel.autoPinEdge(.left, to: .right, of: cartImageView, withOffset: 20)

        self.view.addSubview(longDividerView)

        longDividerView.autoPinEdge(.top, to: .bottom, of: cartImageView, withOffset: 10)
        longDividerView.autoPinEdge(.left, to: .left, of: cartImageView)
        
        self.view.addSubview(shareButton)
        
        let shareView = UIView()

        shareButton.autoSetDimensions(to: CGSize(width: 130, height: 50))
        shareButton.addSubview(shareView)

        shareButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        

        shareButton.positionAboveItem(returnButton, offset: 40)
        shareView.autoAlignAxis(toSuperviewAxis: .horizontal)
        shareView.autoAlignAxis(toSuperviewAxis: .vertical)
        shareView.autoSetDimensions(to: CGSize(width: 130, height: 50))
        shareView.isUserInteractionEnabled = false
        
        shareView.addSubview(shareImageView)
        shareImageView.autoPinEdge(toSuperviewEdge: .left)
        shareImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        shareView.addSubview(shareLabel)
        shareLabel.positionToTheRightOfItem(shareImageView, offset: 10)
        shareLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        shareView.sizeToFit()

        subShareLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        subShareLabel.positionBelowItem(shareView, offset: 5)
    }
    
    internal func decorateImage(_ imageView: UIImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.white
            decorateLabel.textAlignment = .center
            decorateLabel.lineBreakMode = .byWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: (self.product?.name)!)
            attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
            
            decorateLabel.attributedText = attrString
            decorateLabel.font = UIFont.LatoRegularSmall()
            self.view.addSubview(decorateLabel)
            return decorateLabel
        }()
        
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = UIColor.DarkGray()
            bottomView.layer.cornerRadius = 3
            return bottomView
        }()
        
        if (imageView?.image != nil) {
            imageView?.addSubview(bottomView)
            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .left)
            bottomView.autoPinEdge(toSuperviewEdge: .right)
            bottomView.autoSetDimension(.height, toSize: 30)
            bottomView.addSubview(decorateLabel)
            decorateLabel.autoPinEdge(.left, to: .left, of: bottomView, withOffset: 10)
            decorateLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        }
    }

    @objc func returnToFeedPressed() {
        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func shareProduct() {
        let name = (product?.name)!
        // TODO: update with artist name 
        let companyName = "artist name"

        // TODO: fix "xxx" to app store's link!
        let shareString = "\(name) by \(companyName) – curated by @MistMarked. Link: xxx"
        
        let activityViewController = UIActivityViewController(activityItems: [shareString as NSString, mainImage!], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }

}
