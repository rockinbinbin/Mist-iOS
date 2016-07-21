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
    }
    
    // MARK: - Layout
    
    private var hasProductResults: Bool = false {
        didSet {
            productsLabel.hidden = !hasProductResults
            brandLabelUnderScrollViewConstraint?.active = hasProductResults
            brandLabelTopPinConstraint?.active = !hasProductResults
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
        
        super.updateConstraints()
    }
    
    // MARK: - Search Results
    
    func updateSearchResults(products: [Feed.Item], brands: [SearchResult.Brand]) {
        clearSearchResults()
        
        hasProductResults = !products.isEmpty
        
        setNeedsLayout()
        
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
