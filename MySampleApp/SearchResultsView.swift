//
//  SearchResults.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchResultsView: UIView, SearchResultProductViewDelegate, SearchResultBrandViewDelegate {
    
    // MARK: - Init
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        return scrollView
    }()
    
    class Label: UILabel {
        convenience init(title: String) {
            self.init()
            
            let attributes = [
                NSFontAttributeName: UIFont(name: "Lato-Bold", size: 15)!,
                NSKernAttributeName: 2.0,
                NSForegroundColorAttributeName: UIColor.blackColor()
            ]

            attributedText = NSAttributedString(string: title, attributes: attributes)
        }
    }
    
    private lazy var productsLabel: UILabel = {
        let label = Label(title: "PRODUCTS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var brandsLabel: UILabel = {
        let label = Label(title: "BRANDS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var productsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var noResultsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Bold", size: 18)
        label.textColor = UIColor(white: 0.47, alpha: 1.0)
        label.text = "No results!"
        self.addSubview(label)
        return label
    }()
    
    private lazy var noResultsDescriptionButton: UIButton = {
        let button = UIButton()
        
        let title = "Have a product suggestion? Email us."
        let greySection = "Have a product suggestion? "
        
        let grey = UIColor(white: 0.64, alpha: 1.0)
        let greyRange = NSMakeRange(0, greySection.characters.count)
        
        let blue = Constants.Colors.DoneBlue
        let blueRange = NSMakeRange(greySection.characters.count, title.characters.count - greySection.characters.count)
        
        var attributedTitle = NSMutableAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont(name: "Lato-Regular", size: 15)!
            ])
        
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: grey, range: greyRange)
        attributedTitle.addAttribute(NSForegroundColorAttributeName, value: Constants.Colors.DoneBlue, range: blueRange)
        
        button.setAttributedTitle(attributedTitle, forState: .Normal)
        
        button.addTarget(self, action: #selector(SearchResultsView.showEmailSuggestionTemplate), forControlEvents: .TouchUpInside)
        
        self.addSubview(button)
        
        return button
    }()
    
    private var productViews: [SearchResultProductView] = []
    private var brandViews: [SearchResultBrandView] = []
    
    private var leftOffset: CGFloat = 29
    
    private func displayProduct(productView: SearchResultProductView) {
        let size = productView.preferredSize
        
        productView.layer.opacity = 0
        productView.userInteractionEnabled = false
        
        productsScrollView.addSubview(productView)
        
        productView.sizeToHeight(size.height)
        productView.sizeToWidth(size.width)
        productView.pinToTopEdgeOfSuperview()
        
        let padding: CGFloat = 20
        
        productView.pinToLeftEdgeOfSuperview(offset: leftOffset)
        
        leftOffset += (padding + size.width)
        productsScrollView.contentSize = CGSizeMake(leftOffset, 191)
        
        UIView.animateWithDuration(0.2, animations: {
            productView.layer.opacity = 1
            }, completion: { (Bool) -> Void in
            productView.userInteractionEnabled = true
        })
    }
    
    private lazy var previousBrandView: UIView? = nil
    
    private func displayBrand(brandView: SearchResultBrandView) {

        brandView.layer.opacity = 0
        brandView.userInteractionEnabled = false
        
        scrollView.addSubview(brandView)
        
        if previousBrandView == nil {
            brandView.positionBelowItem(brandsLabel, offset: 25)
        } else {
            brandView.positionBelowItem(previousBrandView!, offset: 17)
        }
        
        previousBrandView = brandView
        
        let screenWidth = UIApplication.sharedApplication().keyWindow!.frame.size.width
        
        brandView.pinToLeftEdgeOfSuperview()
        brandView.sizeToWidth(screenWidth)
        brandView.sizeToHeight(100)
        
        UIView.animateWithDuration(0.2, animations: {
            brandView.layer.opacity = 1
            }, completion: { (Bool) -> Void in
                brandView.userInteractionEnabled = true
        })
    }
    
    private func clearSearchResults() {
        for product in productViews {
            product.removeFromSuperview()
        }
        
        productViews = []
        leftOffset = 29
        
        for brand in brandViews {
            brand.removeFromSuperview()
        }
        
        brandViews = []
        previousBrandView = nil
    }
    
    // MARK: - Layout
    
    private var hasProductResults: Bool = false {
        didSet {
            productsLabel.hidden = !hasProductResults
            
            if hasBrandResults {
                brandLabelTopPinConstraint?.active = !hasProductResults
                brandLabelUnderScrollViewConstraint?.active = hasProductResults
            } else {
                brandLabelUnderScrollViewConstraint?.active = hasProductResults
                brandLabelTopPinConstraint?.active = !hasProductResults
            }
        }
    }
    
    private var hasBrandResults: Bool = false {
        didSet {
            brandsLabel.hidden = !hasBrandResults
        }
    }
    
    var scrollViewHeight: CGFloat {
        get {
            var height: CGFloat = 0
            
            if hasProductResults {
                height += 270
            }
            
            if hasBrandResults {
                height += 80 + (CGFloat(brandViews.count) * 117)
            }
            
            return height
        }
    }
    
    var brandLabelTopPinConstraint: NSLayoutConstraint? = nil
    var brandLabelUnderScrollViewConstraint: NSLayoutConstraint? = nil
    
    override func updateConstraints() {
        scrollView.pinToEdgesOfSuperview()
        
        productsLabel.pinToTopEdgeOfSuperview(offset: 31)
        productsLabel.pinToLeftEdgeOfSuperview(offset: 29)
        
        let screenWidth = UIApplication.sharedApplication().keyWindow!.frame.size.width
        
        productsScrollView.sizeToHeight(191)
        productsScrollView.pinToLeftEdgeOfSuperview()
        productsScrollView.sizeToWidth(screenWidth)
        productsScrollView.positionBelowItem(productsLabel, offset: 30)
        
        brandsLabel.pinToLeftEdgeOfSuperview(offset: 29)
        brandLabelUnderScrollViewConstraint = brandsLabel.positionBelowItem(productsScrollView, offset: 30)
        brandLabelTopPinConstraint = brandsLabel.pinToTopEdgeOfSuperview(offset: 31)
        brandLabelTopPinConstraint!.active = false
        
        noResultsTitle.centerHorizontallyInSuperview()
        noResultsTitle.centerVerticallyInSuperview(offset: -30)
        
        noResultsDescriptionButton.centerHorizontallyInSuperview()
        noResultsDescriptionButton.positionBelowItem(noResultsTitle, offset: 5)
        
        super.updateConstraints()
    }
    
    // MARK: - Search Results
    
    func updateSearchResults(products: [Feed.Item], brands: [SearchResult.Brand]) {
        scrollView.setContentOffset(CGPointZero, animated: false)
        clearSearchResults()
        
        hasProductResults = !products.isEmpty
        hasBrandResults = !brands.isEmpty
        
        let noResults = products.isEmpty && brands.isEmpty
        
        noResultsTitle.hidden = !noResults
        noResultsDescriptionButton.hidden = !noResults
        noResultsDescriptionButton.userInteractionEnabled = noResults
        
        for (index, product) in products.enumerate() {
            let searchResultProductView = SearchResultProductView(item: product)
            productViews.append(searchResultProductView)

            searchResultProductView.delegate = self
            searchResultProductView.loadImage()
            searchResultProductView.tag = index
        }
        
        for (index, brand) in brands.enumerate() {
            let searchResultBrandView = SearchResultBrandView(brand: brand)
            brandViews.append(searchResultBrandView)
            
            searchResultBrandView.delegate = self
            searchResultBrandView.loadImage()
            searchResultBrandView.tag = index
        }
        
        scrollView.contentSize.height = scrollViewHeight
    }
    
    // MARK: - Contact
    
    func showEmailSuggestionTemplate() {
        print("Show email suggestion template")
    }
    
    // MARK: - Delegate Methods
    
    func didLoadProductImage(tag: Int, error: NSError?) {
        guard error == nil else {
            return
        }
        
        let productView = productViews.filter({$0.tag == tag}).first!
        displayProduct(productView)
    }
    
    func didLoadBrandImage(tag: Int, error: NSError?) {
        guard error == nil else {
            return
        }
        
        let brandView = brandViews.filter({$0.tag == tag}).first!
        displayBrand(brandView)
    }
}
