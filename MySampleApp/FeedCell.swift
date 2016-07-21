//
//  FeedCell.swift
//  Mist
//
//  Created by Steven on 6/14/16.
//
//

import UIKit
import DLImageLoader

class FeedCell: UICollectionViewCell {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blackColor()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var product: Feed.Item? = nil {
        didSet {
            guard let item = product else {
                return
            }
            
            setTitleText(item.name)
            setPrice(item.price)
        }
    }
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    private lazy var blackGradientOverlay: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRectMake(0.0, 0.0, 1000, 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, atIndex: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.addSubview(_blackGradientOverlay)
        
        return _blackGradientOverlay
    }()
    
    private lazy var nameLabel: UILabel = {
        let _nameLabel = UILabel()
        _nameLabel.textColor = UIColor.whiteColor()
        _nameLabel.numberOfLines = 0
        _nameLabel.lineBreakMode = .ByWordWrapping
        self.addSubview(_nameLabel)
        return _nameLabel
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteColor()
        label.textAlignment = .Right
        self.addSubview(label)
        return label
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
        imageView.pinToEdgesOfSuperview()
        
        blackGradientOverlay.pinToBottomEdgeOfSuperview()
        blackGradientOverlay.pinToLeftEdgeOfSuperview()
        blackGradientOverlay.pinToRightEdgeOfSuperview()
        blackGradientOverlay.sizeToHeight(75)
        
        nameLabel.pinToBottomEdgeOfSuperview(offset: 5)
        nameLabel.pinToLeftEdgeOfSuperview(offset: 5)
        nameLabel.sizeToWidth(UIApplication.sharedApplication().keyWindow!.frame.size.width / 2 - 30)
        
        priceLabel.pinToBottomEdgeOfSuperview(offset: 5)
        priceLabel.pinToRightEdgeOfSuperview(offset: 5)
        priceLabel.sizeToWidth(40)
    }
    
    func setImage(url: String, completion: ((completed: Bool, image: UIImage?) -> ())?) {
        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
            completion?(completed: Bool(error == nil), image: image)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
            }
        }
    }
    
    private func setTitleText(name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercaseString, attributes: attributes as? [String : AnyObject])
        
        nameLabel.attributedText = attributedTitle
        nameLabel.sizeToFit()
    }
    
    private func setPrice(price: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: "$\(Int(Double(price)!))", attributes: attributes as? [String : AnyObject])
        priceLabel.attributedText = attributedTitle
        priceLabel.sizeToFit()
    }
    
    // MARK: - Interface
    
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
    
    var productID: String? {
        get {
            return product?.id
        }
    }
    
    var productDescription: String? {
        get {
            return product?.description
        }
    }
}
