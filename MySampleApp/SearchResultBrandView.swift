//
//  SearchResultBrand.swift
//  Mist
//
//  Created by Steven on 7/20/16.
//
//

import UIKit
import DLImageLoader

protocol SearchResultBrandViewDelegate {
    func didLoadBrandImage(tag: Int, error: NSError?)
}

class SearchResultBrandView: UIView {
    
    // MARK: - Model
    
    var brand: SearchResult.Brand? = nil
    
    // MARK: - Delegate
    
    var delegate: SearchResultBrandViewDelegate? = nil
    
    // MARK: - Init
    
    convenience init(brand: SearchResult.Brand) {
        self.init(frame: CGRectZero)
        self.brand = brand
        self.brandLabel.text = brand.name
        self.descriptionLabel.text = brand.description
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        setNeedsLayout()
    }
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.layer.borderColor = UIColor(white: 0.92, alpha: 1.0).CGColor
        imageView.layer.borderWidth = 1.0
        imageView.layer.masksToBounds = true
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var brandLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.font = UIFont(name: "Lato-Bold", size: 17)
        label.textColor = .blackColor()
        self.addSubview(label)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .ByTruncatingTail
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = UIColor(white: 0.47, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    
    private lazy var bottomBorder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
        self.addSubview(view)
        return view
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Search-Forward"))
        self.addSubview(imageView)
        return imageView
    }()
    
    /**
     Loads the image and notifies the delegate.
     */
    func loadImage() {
        DLImageLoader.sharedInstance.imageFromUrl(brand!.imageURL) { (error, image) in
            guard error == nil else {
                self.delegate?.didLoadBrandImage(self.tag, error: error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
                self.delegate?.didLoadBrandImage(self.tag, error: nil)
            }
        }
    }
    
    override func updateConstraints() {
        imageView.sizeToWidth(63)
        imageView.sizeToHeight(80)
        imageView.pinToLeftEdgeOfSuperview(offset: 29)
        imageView.pinToTopEdgeOfSuperview()
        
        arrowImageView.centerVerticallyToItem(imageView)
        arrowImageView.sizeToWidth(8)
        arrowImageView.sizeToHeight(13)
        arrowImageView.pinToRightEdgeOfSuperview(offset: 10)
        
        brandLabel.pinToTopEdgeOfSuperview(offset: -3)
        brandLabel.positionToTheRightOfItem(imageView, offset: 17)
        brandLabel.pinToRightEdgeOfSuperview(offset: 23)
        
        descriptionLabel.positionToTheRightOfItem(imageView, offset: 17)
        descriptionLabel.positionBelowItem(brandLabel, offset: 4)
        descriptionLabel.sizeToWidth(UIApplication.sharedApplication().keyWindow!.frame.width - 140)
        
        bottomBorder.sizeToHeight(1)
        bottomBorder.pinToLeftEdgeOfSuperview(offset: 30)
        bottomBorder.pinToRightEdgeOfSuperview(offset: 38)
        bottomBorder.pinToBottomEdgeOfSuperview()
        
        super.updateConstraints()
    }
}