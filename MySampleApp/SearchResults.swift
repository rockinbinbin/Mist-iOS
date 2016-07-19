//
//  SearchResults.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchResults: UIView {
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        return scrollView
    }()
    
    class SearchResultsLabel: UILabel {
        convenience init(title: String) {
            self.init()
            
            attributedText = NSAttributedString(string: title, attributes: [
                NSFontAttributeName: UIFont(name: "Lato-Bold", size: 15)!,
                NSKernAttributeName: 2.0,
                NSForegroundColorAttributeName: UIColor.blackColor()
                ])
        }
    }
    
    private lazy var productsLabel: UILabel = {
        let label = SearchResultsLabel(title: "PRODUCTS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    private lazy var brandsLabel: UILabel = {
        let label = SearchResultsLabel(title: "BRANDS")
        self.scrollView.addSubview(label)
        return label
    }()
    
    
    
    // MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
    }
}
