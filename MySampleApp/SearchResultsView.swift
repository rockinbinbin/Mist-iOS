//
//  SearchResults.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchResultsView: UIView, SearchResultProductDelegate {
    
    // MARK: - Init
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
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
        self.scrollView.addSubview(scrollView)
        return scrollView
    }()
    
    private var productViews: [SearchResultProduct] = []
    private var leftOffset: CGFloat = 29
    
    private func displayProduct(productView: SearchResultProduct) {
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
        
        UIView.animateWithDuration(0.2, animations: {
            productView.layer.opacity = 1
            }, completion: { (Bool) -> Void in
            productView.userInteractionEnabled = true
        })
    }
    
    private func clearSearchResults() {
        for product in productViews {
            product.removeFromSuperview()
        }
        
        productViews = []
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        
        scrollView.pinToEdgesOfSuperview()
        
        productsLabel.pinToTopEdgeOfSuperview(offset: 31)
        productsLabel.pinToLeftEdgeOfSuperview(offset: 29)
        
        let screenWidth = UIApplication.sharedApplication().keyWindow!.frame.size.width
        
        productsScrollView.sizeToHeight(191)
        productsScrollView.pinToLeftEdgeOfSuperview()
        productsScrollView.sizeToWidth(screenWidth)
        productsScrollView.positionBelowItem(productsLabel, offset: 19)
        
        super.updateConstraints()
    }
    
    // MARK: - Search Results
    
    func updateSearchResults(products: [Feed.Item], brands: [SearchResult.Brand]) {
        for (index, product) in products.enumerate() {
            let searchResultProduct = SearchResultProduct(item: product)
            productViews.append(searchResultProduct)
            searchResultProduct.delegate = self
            searchResultProduct.loadImage()
            searchResultProduct.tag = index
        }
    }
    
    // MARK: - Delegate Methods
    
    func didLoadImage(tag: Int, error: NSError?) {
        guard error == nil else {
            return
        }
        
        let productView = productViews.filter({$0.tag == tag}).first!
        displayProduct(productView)
    }
}
