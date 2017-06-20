//
//  SearchResultProductView.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

protocol SearchResultProductViewDelegate {
    func didLoadProductImage(_ tag: Int, error: NSError?)
}

/**
 Represents a product cell in the search results view controller.
 */
class SearchResultProductView: UIView {
    
    // MARK: - Init
    
    convenience init(item: Feed.Item) {
        self.init(frame: CGRect.zero)
        self.item = item
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor(white: 0.92, alpha: 1.0).cgColor
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
    
    var delegate: SearchResultProductViewDelegate? = nil
    
    /**
     Loads the image and notifies the delegate.
     */
    func loadImage() {
        // TODO: DLImageLoader
//        DLImageLoader.sharedInstance.imageFromUrl(item!.imageURL) { (error, image) in
//            guard error == nil else {
//                self.delegate?.didLoadProductImage(self.tag, error: error)
//                return
//            }
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                self.imageView.image = image
//                self.delegate?.didLoadProductImage(self.tag, error: nil)
//            }
//        }
    }
    
    // MARK: - Model
    
    var item: Feed.Item? = nil
    
    // MARK: - UI Components
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        return imageView
    }()
    
    fileprivate class Label: UILabel {
        enum Style {
            case product
            case brand
            case price
        }
        
        convenience init(title: String, style: Style) {
            self.init()
            
            text = title
            textColor = .white
            lineBreakMode = .byTruncatingTail
            
            switch style {
            case .product: font = UIFont(name: "Lato-Bold", size: 13)!
            case .brand: font = UIFont(name: "Lato-Regular", size: 12)!
            case .price: font = UIFont(name: "Lato-Regular", size: 14)!
            }
        }
    }
    
    fileprivate lazy var productLabel: UILabel = {
        let label = Label(title: self.item!.name, style: .product)
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var brandLabel: UILabel = {
        let label = Label(title: self.item!.brand, style: .brand)
        self.addSubview(label)
        return label
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = Label(title: "$\(Int(Double(self.item!.price)!))", style: .price)
        label.textAlignment = .right
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
            
            let minimumWidth: CGFloat = 100
            
            if size.width < minimumWidth {
                size.width = minimumWidth
            }
            
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
