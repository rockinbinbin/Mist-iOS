//
//  SearchResults.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit
import PureLayout

class SearchResultsView: UIView, SearchResultProductViewDelegate, SearchResultBrandViewDelegate {
    
    // MARK: - Init
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        return scrollView
    }()
    
    fileprivate lazy var productsLabel: UILabel = {
        let label = UILabel()
        label.styleSmallBlackLabel("PRODUCTS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var brandsLabel: UILabel = {
        let label = UILabel()
        label.styleSmallBlackLabel("BRANDS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    fileprivate lazy var productsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.addSubview(scrollView)
        return scrollView
    }()
    
    fileprivate lazy var noResultsTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.LatoBoldMedium()
        label.textColor = UIColor(white: 0.47, alpha: 1.0)
        label.text = "No results!"
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var noResultsDescriptionButton: UIButton = {
        let button = UIButton()
        
        let title = "Have a product suggestion? Email us."
        let greySection = "Have a product suggestion? "
        
        let grey = UIColor(white: 0.64, alpha: 1.0)
        let greyRange = NSMakeRange(0, greySection.count)
        
        let blue = UIColor.DoneBlue()
        let blueRange = NSMakeRange(greySection.count, title.count - greySection.count)
        
        var attributedTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedStringKey.font: UIFont.LatoRegularMedium()
            ])
        
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: grey, range: greyRange)
        attributedTitle.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.DoneBlue(), range: blueRange)
        
        button.setAttributedTitle(attributedTitle, for: UIControlState())
        
        button.addTarget(self, action: #selector(SearchResultsView.showEmailSuggestionTemplate), for: .touchUpInside)
        
        self.addSubview(button)
        
        return button
    }()
    
    fileprivate var productViews: [SearchResultProductView] = []
    fileprivate var brandViews: [SearchResultBrandView] = []
    
    fileprivate var leftOffset: CGFloat = 29
    
    fileprivate func displayProduct(_ productView: SearchResultProductView) {

        DispatchQueue.main.async {

            let size = productView.preferredSize
            productView.layer.opacity = 0
            productView.isUserInteractionEnabled = false
            self.productsScrollView.addSubview(productView)

            productView.autoSetDimensions(to: CGSize(width: size.width, height: size.height))
            productView.autoPinEdge(toSuperviewEdge: .top)

            let padding: CGFloat = 20

            productView.autoPinEdge(toSuperviewEdge: .left, withInset: self.leftOffset)

            self.leftOffset += (padding + size.width)
            self.productsScrollView.contentSize = CGSize(width: self.leftOffset, height: 191)

            UIView.animate(withDuration: 0.2, animations: {
                productView.layer.opacity = 1
            }, completion: { (Bool) -> Void in
                productView.isUserInteractionEnabled = true
            })
        }
    }
    
    fileprivate lazy var previousBrandView: UIView? = nil
    
    fileprivate func displayBrand(_ brandView: SearchResultBrandView) {

        brandView.layer.opacity = 0
        brandView.isUserInteractionEnabled = false
        
        scrollView.addSubview(brandView)
        
        if previousBrandView == nil {
            brandView.autoPinEdge(.top, to: .bottom, of: brandsLabel, withOffset: 25)
        } else {
            brandView.autoPinEdge(.top, to: .bottom, of: previousBrandView!, withOffset: 17)
        }
        
        previousBrandView = brandView
        
        let screenWidth = UIApplication.shared.keyWindow!.frame.size.width

        brandView.autoPinEdge(toSuperviewEdge: .left)
        brandView.autoSetDimensions(to: CGSize(width: screenWidth, height: 100))
        
        UIView.animate(withDuration: 0.2, animations: {
            brandView.layer.opacity = 1
            }, completion: { (Bool) -> Void in
                brandView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func clearSearchResults() {
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
    
    fileprivate var hasProductResults: Bool = false {
        didSet {
            productsLabel.isHidden = !hasProductResults
            
            if hasBrandResults {
                brandLabelTopPinConstraint?.isActive = !hasProductResults
                brandLabelUnderScrollViewConstraint?.isActive = hasProductResults
            } else {
                brandLabelUnderScrollViewConstraint?.isActive = hasProductResults
                brandLabelTopPinConstraint?.isActive = !hasProductResults
            }
        }
    }
    
    fileprivate var hasBrandResults: Bool = false {
        didSet {
            brandsLabel.isHidden = !hasBrandResults
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

        scrollView.autoPinEdgesToSuperviewEdges()

        productsLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 31)
        productsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 29)
        
        let screenWidth = UIApplication.shared.keyWindow!.frame.size.width


        productsScrollView.autoSetDimensions(to: CGSize(width: screenWidth, height: 191))
        productsScrollView.autoPinEdge(toSuperviewEdge: .left)
        productsScrollView.autoPinEdge(.top, to: .bottom, of: productsLabel, withOffset: 30)

        brandsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 29)

        brandLabelUnderScrollViewConstraint = brandsLabel.positionBelowItem(productsScrollView, offset: 30)
        brandLabelTopPinConstraint = brandsLabel.pinToTopEdgeOfSuperview(offset: 31)
        brandLabelTopPinConstraint!.isActive = false

        noResultsTitle.autoAlignAxis(toSuperviewAxis: .horizontal)

        noResultsTitle.centerVerticallyInSuperview(offset: -30)

        noResultsDescriptionButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        noResultsDescriptionButton.autoPinEdge(.top, to: .bottom, of: noResultsTitle, withOffset: 5)
        super.updateConstraints()
    }
    
    // MARK: - Search Results
    
    func updateSearchResults(_ products: [Feed.Post], brands: [SearchResult.Brand]) {
        scrollView.setContentOffset(CGPoint.zero, animated: false)
        clearSearchResults()
        
        hasProductResults = !products.isEmpty
        hasBrandResults = !brands.isEmpty
        
        let noResults = products.isEmpty && brands.isEmpty
        
        noResultsTitle.isHidden = !noResults
        noResultsDescriptionButton.isHidden = !noResults
        noResultsDescriptionButton.isUserInteractionEnabled = noResults
        
        for (index, product) in products.enumerated() {
            let searchResultProductView = SearchResultProductView(item: product)
            productViews.append(searchResultProductView)

            searchResultProductView.delegate = self
            searchResultProductView.loadImage()
            searchResultProductView.tag = index
        }
        
        for (index, brand) in brands.enumerated() {
            let searchResultBrandView = SearchResultBrandView(brand: brand)
            brandViews.append(searchResultBrandView)
            
            searchResultBrandView.delegate = self
            searchResultBrandView.loadImage()
            searchResultBrandView.tag = index
        }
        
        scrollView.contentSize.height = scrollViewHeight
    }
    
    // MARK: - Contact
    
    @objc func showEmailSuggestionTemplate() {
        print("Show email suggestion template")
    }
    
    // MARK: - Delegate Methods
    
    func didLoadProductImage(_ tag: Int, error: NSError?) {
        guard error == nil else {
            return
        }
        
        let productView = productViews.filter({$0.tag == tag}).first!
        displayProduct(productView)
    }
    
    func didLoadBrandImage(_ tag: Int, error: NSError?) {
        guard error == nil else {
            return
        }
        
        let brandView = brandViews.filter({$0.tag == tag}).first!
        displayBrand(brandView)
    }
}
