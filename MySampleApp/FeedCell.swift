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
    
    var productID: String? = nil
    
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
        self.addSubview(_nameLabel)
        return _nameLabel
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
    }
    
    func setImage(url: String, completion: ((completed: Bool, image: UIImage?) -> ())?) {
        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
            completion?(completed: Bool(error == nil), image: image)
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
            }
        }
    }
    
    func setTitleText(name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 9)!,
            NSForegroundColorAttributeName:UIColor.whiteColor(),
            NSKernAttributeName:CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercaseString, attributes: attributes as? [String : AnyObject])
        
        nameLabel.attributedText = attributedTitle
        nameLabel.sizeToFit()
    }
    
    // MARK: - Interface
    
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
}