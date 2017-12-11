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
import MessageUI

class ProductViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate, UIScrollViewDelegate, STPAddCardViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = .black
        setViewConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateInComponents()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: viewBrandButton.frame.maxY + bottomBar.frame.height + 10)
    }
    
    // MARK: - Animation
    
    func animateInComponents() {
        let components: [UIView] = [productTitleLabel, byCompanyLabel, titleLine, productPriceLabel, descriptionLabel, imageViewScrollView, shippingLine, packageIcon, shippingSublabel, shippingLabel, returnIcon, returnLabel, returnSubLabel]
        
        for component in components {
            component.layer.opacity = 0
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            for component in components {
                component.layer.opacity = 1
            }
        }) 
    }
    
    // MARK: - Model
    
    var product: Feed.Post? = nil {
        didSet {
            guard product != nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.setPriceText("$\(Int(Double(self.product!.price)/100.0))")
                self.setTitleText(self.product!.name)
                // Instead, query for Artist by artist ID
                //self.setCompanyText(self.product!.brand)
                self.setDescriptionLabel(self.product!.description)
                self.buyButton.price = Float(Double(self.product!.price))
                //self.viewBrandLabel?.text = "Browse more from \(self.product!.brand)"
            }
            
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }
    }
    
    var imageHeight: CGFloat = 200
    
    var imageURLs: [String]? = nil {
        didSet {
            guard let array = imageURLs else {
                return
            }
            
            for string in array {
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                    let url = URL(string: string)
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {
                        self.addImageToScrollView(UIImage(data: data!)!)
                    });
                }
            }
            
            // more products by company:
            //addProductToScrollView(product!, productImage: image)
        }
    }
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else { return }
            mainImageView.image = image
            imageHeight = (image.size.height / image.size.width) * self.view.frame.size.width
            imageHeightConstraint?.constant = imageHeight
        }
    }
    
    var delegate: FeedProductTransitionDelegate? = nil
    
    // MARK: - UI Components
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 2.0)
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    fileprivate lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var gradientView: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 1000, height: 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, at: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.scrollView.addSubview(_blackGradientOverlay)
        
        return _blackGradientOverlay
    }()
    
    fileprivate lazy var topGradientView: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 1000, height: 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, at: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.mainImageView.addSubview(_blackGradientOverlay)
        
        _blackGradientOverlay.layer.opacity = 0
        
        return _blackGradientOverlay
    }()
    
    fileprivate lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var byCompanyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate func setTitleText(_ name: String) {
        let attributes: NSDictionary = [
            NSAttributedStringKey.font:UIFont.LatoRegularMedium(),
            NSAttributedStringKey.foregroundColor:UIColor.white,
            NSAttributedStringKey.kern:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercased(), attributes: attributes as? [NSAttributedStringKey : Any])
        
        productTitleLabel.attributedText = attributedTitle
        productTitleLabel.numberOfLines = 0
        productTitleLabel.sizeToFit()
    }
    
    fileprivate func setCompanyText(_ name: String) {
        let string = NSMutableAttributedString(string: "by \(name)")
        
        string.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor(white: 210/255.0, alpha: 1), range: NSMakeRange(0, string.length))
        
        string.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, "by ".count))
        
        string.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange("by ".count, name.count))
        
        byCompanyLabel.attributedText = string
        
        // "More by" label
        
        let moreString = NSMutableAttributedString(string: "More by \(name)".uppercased())
        
        moreString.addAttributes([
            NSAttributedStringKey.font: UIFont.LatoBoldSmall(),
            NSAttributedStringKey.kern: 2.0,
            NSAttributedStringKey.foregroundColor: UIColor(white: 0.71, alpha: 1.0)
            ], range: NSMakeRange(0, moreString.length))
        
        moreLabel.attributedText = moreString
    }
    
    fileprivate lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var titleLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 1.0, alpha: 0.21)
        self.scrollView.addSubview(line)
        return line
    }()
    
    fileprivate func setPriceText(_ name: String) {
        let attributes: NSDictionary = [
            NSAttributedStringKey.font:UIFont.LatoRegularMedium(),
            NSAttributedStringKey.foregroundColor:UIColor.white,
            NSAttributedStringKey.kern:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercased(), attributes: attributes as? [NSAttributedStringKey : Any])
        
        productPriceLabel.attributedText = attributedTitle
        productPriceLabel.sizeToFit()
    }
    
    fileprivate func setDescriptionLabel(_ name: String) {
        descriptionLabel.text = name
    }
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.LatoRegularSmall()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(label)
        return label
    }()
    
    let moreImagesHeight: CGFloat = 160
    
    fileprivate lazy var imageViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.09)
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(scrollView)
        return scrollView
    }()
    
    var moreImages: [UIImageView] = []
    
    fileprivate func addImageToScrollView(_ image: UIImage) {
        
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
        
        let offset: CGFloat = (moreImages.count != 0) ? 20 : 0
        
        moreImages.append(imageView)
        
        imageViewScrollView.contentSize = CGSize(width: imageViewScrollView.contentSize.width + imageWidth + offset, height: moreImagesHeight)
    }
    
    fileprivate lazy var bottomBar: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.view.addSubview(view)
        return view
    }()
    
    fileprivate lazy var buyButton: BuyButton = {
        let button = BuyButton()
        button.backgroundColor = UIColor.BuyBlue()
        button.addTarget(self, action: #selector(purchaseItem), for: .touchUpInside)
//        self.bottomBar.addSubview(button)
        return button
    }()
    
    fileprivate lazy var shareButton: UIButton = {
        let button = UIButton()
        button.layer.opacity = 0.6
        button.setImage(UIImage(named: "Products-Share"), for: UIControlState())
        self.bottomBar.addSubview(button)
        return button
    }()
    
    var liked = false
    
    fileprivate lazy var likeButton: UIButton = {
        let button = UIButton()
        button.layer.opacity = 0.6
        button.setImage(UIImage(named: "Products-Heart"), for: UIControlState())
        button.addTarget(self, action: #selector(heartPressed), for: .touchUpInside)
        self.bottomBar.addSubview(button)
        return button
    }()
    
    fileprivate lazy var closeButton: UIButton = {
        let button = UIButton()
        
        button.setBackgroundImage(UIImage(named: "Product-X"), for: UIControlState())
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        
        self.scrollView.addSubview(button)
        return button
    }()
    
    @objc func heartPressed() {
        var newImageTitle: String
        
        if liked {
            newImageTitle = "Products-Heart"
        } else {
            newImageTitle = "Products-Heart-Filled"
        }
        
        likeButton.setImage(UIImage(named: newImageTitle), for: UIControlState())
        liked = !liked
    }
    
    fileprivate lazy var packageIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Product-Ship"))
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var shippingLabel: UILabel = {
        let label = UILabel()
        label.text = "Ships in 2 - 4 business days"
        label.font = UIFont.LatoRegularSmall()
        label.textColor = .white
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var shippingSublabel: UILabel = {
        let label = UILabel()
        label.text = "Arrives July 1 - 2"
        label.font = UIFont.LatoRegularSmall()
        label.textColor = UIColor(white: 1.0, alpha: 0.42)
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var shippingLine: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor(white: 1.0, alpha: 0.21)
        self.scrollView.addSubview(line)
        return line
    }()
    
    fileprivate lazy var returnIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Product-Cart"))
        self.scrollView.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var returnLabel: UILabel = {
        let label = UILabel()
        label.text = "Return free for 14 days"
        label.font = UIFont.LatoRegularSmall()
        label.textColor = .white
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var returnSubLabel: UILabel = {
        let label = UILabel()
        label.text = "Before July 11"
        label.font = UIFont.LatoRegularSmall()
        label.textColor = UIColor(white: 1.0, alpha: 0.42)
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate var sizeLabel: UILabel? = nil
    
    fileprivate lazy var sizeButton: UIButton = {
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
        self.sizeLabel!.textColor = .white
        self.sizeLabel!.font = UIFont.LatoBoldSmall()
        button.addSubview(self.sizeLabel!)
        self.sizeLabel!.centerVerticallyInSuperview()
        self.sizeLabel!.positionToTheRightOfItem(icon, offset: 20)
        
        let dropdown = UIImageView(image: UIImage(named: "Product-Size-Dropdown"))
        button.addSubview(dropdown)
        dropdown.centerVerticallyInSuperview()
        dropdown.pinToRightEdgeOfSuperview(offset: 10)
        dropdown.sizeToWidth(19)
        dropdown.sizeToHeight(11)
        
        button.addTarget(self, action: #selector(sizeButtonPressed), for: .touchUpInside)
        
        self.scrollView.addSubview(button)
        return button
    }()
    
    @objc internal func sizeButtonPressed() {
        let alert = UIAlertController(title: "Choose size", message: "Please select a size", preferredStyle: .actionSheet)
        
        let completion = { (size: String) in
            DispatchQueue.main.async {
                self.sizeLabel?.text = size
            }
        }
        
        for size in ["Small", "Medium", "Large"] {
            alert.addAction(UIAlertAction(title: size, style: .default) { (UIAlertAction) in
                completion(size)
                })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate lazy var moreLabel: UILabel = {
        let moreLabel = UILabel()
        self.scrollView.addSubview(moreLabel)
        return moreLabel
    }()
    
    fileprivate lazy var companyDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Western Sweater Co. is dedicated to producing sustainable sweaters. They produce world-class sweaters at a fraction of the price."
        label.font = UIFont.LatoRegularSmall()
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var moreProductsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = true
        scrollView.isScrollEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(scrollView)
        return scrollView
    }()
    
    class ProductCard: UIView {
        
        convenience init(product: Feed.Post, image: UIImage) {
            self.init(frame: CGRect.zero)
            
            imageView.image = image
            titleLabel.text = product.name
            priceLabel.text = "$\(Int(Double(product.price)))"
            
            imageView.pinToSideEdgesOfSuperview()
            imageView.pinToTopEdgeOfSuperview()
            imageView.pinToBottomEdgeOfSuperview(offset: 35)
            
            bottomBar.pinToSideEdgesOfSuperview()
            bottomBar.sizeToHeight(35)
            bottomBar.pinToBottomEdgeOfSuperview()
            
            titleLabel.pinToLeftEdgeOfSuperview(offset: 8)
            titleLabel.centerVerticallyInSuperview()
            
            priceLabel.pinToRightEdgeOfSuperview(offset: 8)
            priceLabel.centerVerticallyInSuperview()
        }
        
        fileprivate lazy var imageView: UIImageView = {
            let imageView = UIImageView()
            self.addSubview(imageView)
            return imageView
        }()
        
        fileprivate lazy var bottomBar: UIView = {
            let bottomBar = UIView()
            
            bottomBar.backgroundColor = UIColor(white: 0.18, alpha: 1)
            
            self.addSubview(bottomBar)
            return bottomBar
        }()
        
        fileprivate lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.LatoBoldSmall()
            
            self.bottomBar.addSubview(label)
            return label
        }()
        
        fileprivate lazy var priceLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.LatoRegularSmall()
            
            self.bottomBar.addSubview(label)
            return label
        }()
    }
    
    fileprivate lazy var moreProductsHeight: CGFloat = 190
    fileprivate lazy var moreProducts: [ProductCard] = []
    
    fileprivate func addProductToScrollView(_ productData: Feed.Post?, productImage: UIImage?) {
        
        guard let product = productData, let image = productImage else {
            return
        }
        
        let view = ProductCard(product: product, image: image)
        
        moreProductsScrollView.addSubview(view)
        
        let width = (image.size.width / image.size.height) * (moreProductsHeight - 35)
        
        view.sizeToHeight(moreProductsHeight)
        view.sizeToWidth(width)
        
        if moreProducts.count == 0 {
            view.pinToLeftEdgeOfSuperview(offset: 10)
        } else {
            view.positionToTheRightOfItem(moreProducts[moreProducts.count - 1], offset: 10)
        }
        
        view.pinToTopEdgeOfSuperview()
        
        moreProducts.append(view)
        
        let offset: CGFloat = (moreImages.count != 0) ? 20 : 0
        
        moreProductsScrollView.contentSize = CGSize(width: moreProductsScrollView.contentSize.width + width + offset, height: moreProductsHeight)
    }
    
    fileprivate lazy var viewBrandLabel: UILabel? = nil
    
    fileprivate lazy var viewBrandButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        
        let icon = UIImageView(image: UIImage(named: "Product-Bag"))
        button.addSubview(icon)
        icon.centerVerticallyInSuperview()
        icon.pinToLeftEdgeOfSuperview(offset: 10)
        icon.sizeToWidth(16)
        icon.sizeToHeight(18)
        
        self.viewBrandLabel = UILabel()
        self.viewBrandLabel!.text = "Browse more"
        self.viewBrandLabel!.textColor = .white
        self.viewBrandLabel!.font = UIFont.LatoRegularSmall()
        button.addSubview(self.viewBrandLabel!)
        self.viewBrandLabel!.centerVerticallyInSuperview()
        self.viewBrandLabel!.positionToTheRightOfItem(icon, offset: 20)
        
        let dropdown = UIImageView(image: UIImage(named: "Product-Brand-Next"))
        button.addSubview(dropdown)
        dropdown.centerVerticallyInSuperview()
        dropdown.pinToRightEdgeOfSuperview(offset: 10)
        dropdown.sizeToWidth(10)
        dropdown.sizeToHeight(15)
        
        button.addTarget(self, action: #selector(viewBrand), for: .touchUpInside)
        
        self.scrollView.addSubview(button)
        return button
    }()
    
    @objc internal func viewBrand() {
        print("View brand!")
    }
    
    // MARK: - Layout
    
    fileprivate var imageTopConstraint: NSLayoutConstraint? = nil
    fileprivate var imageHeightConstraint: NSLayoutConstraint? = nil
    fileprivate var imageWidthConstraint: NSLayoutConstraint? = nil
    fileprivate var closeButtonTopConstraint: NSLayoutConstraint? = nil
    
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
        productTitleLabel.sizeToWidth(self.view.frame.size.width - 80)
        
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
        
        // More by brand
        
        moreLabel.pinToLeftEdgeOfSuperview(offset: 10)
        moreLabel.positionBelowItem(sizeButton, offset: 30)
        
        companyDescriptionLabel.positionBelowItem(moreLabel, offset: 10)
        companyDescriptionLabel.pinToLeftEdgeOfSuperview(offset: 10)
        companyDescriptionLabel.sizeToWidth(self.view.frame.width - 10)
        
        moreProductsScrollView.pinToLeftEdgeOfSuperview()
        moreProductsScrollView.sizeToHeight(moreProductsHeight)
        moreProductsScrollView.sizeToWidth(self.view.frame.width)
        moreProductsScrollView.positionBelowItem(companyDescriptionLabel, offset: 15)
        
        viewBrandButton.positionBelowItem(moreProductsScrollView, offset: 10)
        viewBrandButton.pinToLeftEdgeOfSuperview()
        viewBrandButton.sizeToWidth(self.view.frame.size.width)
        viewBrandButton.sizeToHeight(58)
        
        // Bottom Bar
        
//        buyButton.pinToTopAndBottomEdgesOfSuperview()
//        buyButton.pinToRightEdgeOfSuperview()
//        buyButton.sizeToWidth(150)
        
//        bottomBar.pinToBottomEdgeOfSuperview()
//        bottomBar.pinToSideEdgesOfSuperview()
//        bottomBar.sizeToHeight(60)
//
//        shareButton.pinToLeftEdgeOfSuperview(offset: 30)
//        shareButton.sizeToHeight(25)
//        shareButton.sizeToWidth(18)
//        shareButton.centerVerticallyInSuperview(offset: -1)
//
//        likeButton.positionToTheRightOfItem(shareButton, offset: 30)
//        likeButton.sizeToWidthAndHeight(22)
//        likeButton.centerVerticallyInSuperview()
    }
    
    // MARK: - Payment
    
    func createCreditCardOptionsAlertController() -> UIAlertController {
        let alert = UIAlertController(title: "Preferred purchase method", message: "Please choose a shipping address.", preferredStyle: .actionSheet)
        
        if PurchaseManager.sharedInstance.deviceSupportsApplePay {
            alert.addAction(UIAlertAction(title: "Apple Pay", style: .default) { (action: UIAlertAction) in
                print("Apple Pay")
                })
        }
        
        alert.addAction(UIAlertAction(title: "+ Add new card", style: .default) { (action: UIAlertAction) in
            self.presentCreditCardEntryForm()
            })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
    }
    
    fileprivate var shouldShowShippingAlertController: Bool {
        return true
    }
    
    func presentCreditCardEntryForm() {
        let ccViewController = AddCreditCardViewController(backgroundImage: mainImageView.image!)
        let ccNavigationController = UINavigationController(rootViewController: ccViewController)
        
        present(ccNavigationController, animated: true, completion: nil)
    }
    
    @objc func purchaseItem() {
        
        guard product != nil else {
            print("Error <ProductViewController>: product was nil")
            return
        }
        
        // TODO: REMOVE THIS
        let shippingVC = PaymentInformationViewController.createWithNavigationController(mainImage!)
        
        self.present(shippingVC, animated: true, completion: nil)

        
//        do {
//            let request: PKPaymentRequest? = try PaymentManager.sharedInstance.generatePaymentRequest(product!)
//            
//            guard request != nil else {
//                print("Device does not support apple pay")
//                buyButtonTapped()
//                return
//            }
//            
//            guard #available(iOS 9, *) else {
//                // BIG TODO:
//                // 1) check if user's shipping info is set
//                // 2) if not, bring up shipping view controller
//                
//                let shippingVC = NewAddressViewController()
//                shippingVC.mainImage = mainImage
//                self.presentViewController(shippingVC, animated: true, completion: nil)
//                
//                return
//            }
//            
//            let paymentViewController = PKPaymentAuthorizationViewController(paymentRequest: request!)
//            paymentViewController.delegate = self
//            presentViewController(paymentViewController, animated: true, completion: nil)
//            
//        } catch {
//            print("PaymentManager error: \(error)")
//            return
//        }
    }
    
    func buyButtonTapped() {
        
        // BIG TODO:
        // 1) check if user's shipping info is set
        // 2) if not, bring up shipping view controller
        
        let shippingVC = NewAddressViewController()
        shippingVC.mainImage = mainImage
        self.present(shippingVC, animated: true, completion: nil)
        
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        // STPAddCardViewController must be shown inside a UINavigationController.
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: STPAddCardViewControllerDelegate
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
 
        
        let functionName = "purchaseItem"
        let parameters = [
            "price": "\(Int(Double((product?.price)!) * 100))",
            "token": token.tokenId,
//            "email": addCardViewController.emailString
            "email": "test@gmail.com"
        ]
        
        AWSCloudLogic.default().invokeFunction(functionName, withParameters: parameters) { (result: Any?, error: Error?) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(error)
                    // error with purchase.. should just stop and not bring dismiss card view controller or bring up purchase confirmed
                    self.showAlert()
                    addCardViewController.setEditing(false, animated: false)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
                let purchaseVC = PurchaseConfirmedViewController()
                purchaseVC.product = self.product
                purchaseVC.mainImage = self.mainImage
                
                self.present(purchaseVC, animated: false, completion: nil) // this animation sucks. TODO: create a better animation in.
                completion(nil)
            }
        }
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        currentPayment = payment
        handlePaymentAuthorizationWithPayment(payment, completion: completion)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        currentPayment = nil
        dismiss(animated: true, completion: nil)
    }
    
    func handlePaymentAuthorizationWithPayment(_ payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> ()) {
        STPAPIClient.shared().createToken(with: payment) { (token, error) -> Void in
            guard error == nil else {
                completion(.failure)
                return
            }
            
            self.createBackendChargeWithToken(token!, completion: completion)
        }
    }
    
    internal func createBackendChargeWithToken(_ token: STPToken, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        let functionName = "purchaseItem"
        let parameters = getPurchaseParameters(token.tokenId)!
        
        AWSCloudLogic.default().invokeFunction(functionName, withParameters: parameters) { (result: Any?, error: Error?) in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failure)
                    return
                }
                self.dismiss(animated: false, completion: nil)
                
                let purchaseVC = PurchaseConfirmedViewController()
                purchaseVC.product = self.product
                purchaseVC.mainImage = self.mainImage
                
                self.present(purchaseVC, animated: false, completion: nil)
                completion(.success)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /**
     The current payment in progress. Used to send contact information to Stripe.
     */
    fileprivate var currentPayment: PKPayment? = nil
    
    /**
     Email address from the current PKPaymentRequest
     */
    fileprivate var email: String? {
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
    
    // create new view controller to enter shipping info, then save them as individual strings and pass back through a delegate
    
    // TODO: make
    
    /**
     Generates the parameters to be used in the Stripe request.
     */
    func getPurchaseParameters(_ tokenId: String) -> [String : String]? {
        guard let item = product else {
            return nil
        }
        guard email != nil else {
            return nil
        }
        
        return [
            "price": "\(Int(item.price / 100))",
            "token": tokenId,
            "email": email!
        ]
    }
    
    // MARK: - Appearance
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - Scrollview
    
    fileprivate lazy var releaseLabel: UILabel = {
        let label = UILabel()
        
        label.layer.opacity = 0
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font:UIFont.LatoBoldSmall(),
            NSAttributedStringKey.foregroundColor:UIColor(white: 1.0, alpha: 0.7),
            NSAttributedStringKey.kern:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: "Release to return to feed".uppercased(), attributes: attributes as? [NSAttributedStringKey : Any])
        
        label.attributedText = attributedTitle
        label.sizeToFit()
        
        self.view.addSubview(label)
        
        return label
    }()
    
    var releaseLabelIsHidden = true
    
    fileprivate func showReleaseLabel() {
        guard releaseLabel.layer.opacity == 0 else {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.releaseLabel.layer.opacity = 1
        }) 
    }
    
    fileprivate func hideReleaseLabel() {
        guard releaseLabel.layer.opacity != 0 else {
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.releaseLabel.layer.opacity = 0
        }) 
    }
    
    var scrollReleaseThreshold: CGFloat = -80
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
    
    @objc internal func closeView() {
        let imageFrame = mainImageView.frame
        
        self.delegate?.transitionToCell(fromImageFrame: imageFrame) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= scrollReleaseThreshold {
            closeView()
        }
    }
    
    func sendEmailButtonTapped() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.dismiss(animated: true, completion: { 
                self.present(mailComposeViewController, animated: true, completion: nil)
            })
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["robinmehta94@gmail.com"]) // TODO: change this to Mist's team email.
        mailComposerVC.setSubject("Payment Failure")
        // TODO: update brand with artist name
        mailComposerVC.setMessageBody("Please help me complete my purchase!\n\nI am trying to purchase \((product?.name)!) by \("artist name").", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Purchase Failed Alert
    func showAlert(){
        let createAccountErrorAlert: UIAlertView = UIAlertView()
        
        createAccountErrorAlert.delegate = self
        
        createAccountErrorAlert.title = "Authorization Failed 🤔"
        createAccountErrorAlert.message = "The credit card information you entered is incorrect. Send us an email if the issue persists!"
        createAccountErrorAlert.addButton(withTitle: "Email us ✉️")
        createAccountErrorAlert.addButton(withTitle: "Try Again!")
        
        createAccountErrorAlert.show()
    }
    
    func alertView(_ View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex{
        case 0:
            sendEmailButtonTapped()
            break;
        case 1:
            break;
        default:
            break;
        }
    }
}
