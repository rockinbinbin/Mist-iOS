//
//  SearchResultProduct.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit
import DLImageLoader

protocol SearchResultProductDelegate {
    func didLoadImage(tag: Int, error: NSError?)
}

/**
 Represents a product cell in the search results view controller.
 */
class SearchResultProduct: UIView {
    
    // MARK: - Init
    
    convenience init(item: Feed.Item) {
        self.init(frame: CGRectZero)
        self.item = item
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(white: 0.92, alpha: 1.0).CGColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        backgroundColor = UIColor(white: 0.18, alpha: 1.0)
        setNeedsLayout()
    }
    
    // MARK: - Delegate
    
    var delegate: SearchResultProductDelegate? = nil
    
    /**
     Loads the image and notifies the delegate.
     */
    func loadImage() {
        DLImageLoader.sharedInstance.imageFromUrl(item!.imageURL) { (error, image) in
            guard error == nil else {
                self.delegate?.didLoadImage(self.tag, error: error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
                self.delegate?.didLoadImage(self.tag, error: nil)
            }
        }
    }
    
    // MARK: - Model
    
    var item: Feed.Item? = nil
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        self.addSubview(imageView)
        return imageView
    }()
    
    private class Label: UILabel {
        enum Style {
            case Product
            case Brand
            case Price
        }
        
        convenience init(title: String, style: Style) {
            self.init()
            
            text = title
            textColor = .whiteColor()
            lineBreakMode = .ByTruncatingTail
            
            switch style {
            case .Product: font = UIFont(name: "Lato-Bold", size: 13)!
            case .Brand: font = UIFont(name: "Lato-Regular", size: 12)!
            case .Price: font = UIFont(name: "Lato-Regular", size: 14)!
            }
        }
    }
    
    private lazy var productLabel: UILabel = {
        let label = Label(title: self.item!.name, style: .Product)
        self.addSubview(label)
        return label
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = Label(title: self.item!.brand, style: .Brand)
        self.addSubview(label)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = Label(title: "$\(Int(Double(self.item!.price)!))", style: .Price)
        label.textAlignment = .Right
        self.addSubview(label)
        return label
    }()
    
    // MARK: - View Sizing
    
    /**
     Used to calculate the size of the view.
     Precondition: the image must be loaded.
     */
    var preferredSize: (height: CGFloat, width: CGFloat) {
        get {
            var size: (height: CGFloat, width: CGFloat) = (191.0, 0.0)
            
            guard let imageSize = imageView.image?.size else {
                return size
            }
            
            let aspectRatio = imageSize.width / imageSize.height
            let imageViewHeight = size.height - 50
            
            size.width = aspectRatio * imageViewHeight
            
            return size
        }
    }
    
    // MARK: - Layout
    
    override func updateConstraints() {
        let bottomBarHeight: CGFloat = 50
        
        imageView.pinToTopEdgeOfSuperview()
        imageView.pinToSideEdgesOfSuperview()
        imageView.pinToBottomEdgeOfSuperview(offset: bottomBarHeight)
        
        priceLabel.pinToBottomEdgeOfSuperview(offset: 8)
        priceLabel.pinToRightEdgeOfSuperview(offset: 8)
        priceLabel.sizeToWidth(30)
        
        productLabel.positionBelowItem(imageView, offset: 8)
        productLabel.pinToLeftEdgeOfSuperview(offset: 8)
        productLabel.sizeToWidth(preferredSize.width - 13)
        
        brandLabel.positionBelowItem(productLabel, offset: 2)
        brandLabel.pinToLeftEdgeOfSuperview(offset: 8)
        brandLabel.positionToTheLeftOfItem(priceLabel, offset: 2)
        
        super.updateConstraints()
    }
}
