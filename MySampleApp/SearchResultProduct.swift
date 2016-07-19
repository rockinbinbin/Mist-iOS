//
//  SearchResultProduct.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchResultProduct: UIView {
    
    convenience init(item: Feed.Item) {
        self.init(frame: CGRectZero)
    }
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }

    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - Layout
    
    override func updateConstraints() {
        super.updateConstraints()
    }
}
