//
//  FeedCell.swift
//  Mist
//
//  Created by Steven on 6/14/16.
//
//

import UIKit
import FLAnimatedImage

class FeedCell: UICollectionViewCell {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
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
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    open var gif: FLAnimatedImageView? = nil
    
    fileprivate lazy var blackGradientOverlay: UIView = {
        let _blackGradientOverlay: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 1000, height: 75.0))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, at: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        self.addSubview(_blackGradientOverlay)
        
        return _blackGradientOverlay
    }()
    
    fileprivate lazy var nameLabel: UILabel = {
        let _nameLabel = UILabel()
        _nameLabel.textColor = UIColor.white
        _nameLabel.numberOfLines = 0
        _nameLabel.lineBreakMode = .byWordWrapping
        self.addSubview(_nameLabel)
        return _nameLabel
    }()
    
    fileprivate lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        self.addSubview(label)
        return label
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
//        if let gif = gif {
//            gif.pinToEdgesOfSuperview()
//        }
//        else {
            imageView.pinToEdgesOfSuperview()
//        }
        
        blackGradientOverlay.pinToBottomEdgeOfSuperview()
        blackGradientOverlay.pinToLeftEdgeOfSuperview()
        blackGradientOverlay.pinToRightEdgeOfSuperview()
        blackGradientOverlay.sizeToHeight(75)
        
        nameLabel.pinToBottomEdgeOfSuperview(offset: 5)
        nameLabel.pinToLeftEdgeOfSuperview(offset: 5)
        nameLabel.sizeToWidth(UIApplication.shared.keyWindow!.frame.size.width / 2 - 30)
        
        priceLabel.pinToBottomEdgeOfSuperview(offset: 5)
        priceLabel.pinToRightEdgeOfSuperview(offset: 5)
        priceLabel.sizeToWidth(40)
    }
    
    func setImage(_ url: String, completion: ((_ completed: Bool, _ image: UIImage?) -> ())?) {
        // TODO: DLImageLoader
//        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
//            completion?(completed: Bool(error == nil), image: image)
//
//            dispatch_async(dispatch_get_main_queue()) {
//                self.imageView.image = image
////                self.imageView.image = UIImage.animatedImageWithAnimatedGIFURL(NSURL(string: url)!)
//            }
//        }
    }
    
//    func setGif(url: String, completion: ((completed: Bool, image: UIImage?) -> ())?) {
//        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
//            completion?(completed: Bool(error == nil), image: image)
//            
//            dispatch_async(dispatch_get_main_queue()) {
//                self.imageView.image = image
//            }
//        }
//    }
    
    fileprivate func setTitleText(_ name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor.white,
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercased(), attributes: attributes as? [String : AnyObject])
        
        nameLabel.attributedText = attributedTitle
        nameLabel.sizeToFit()
    }
    
    fileprivate func setPrice(_ price: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor.white,
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
