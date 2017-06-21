//
//  FeedCell.swift
//  Mist
//
//  Created by Steven on 6/14/16.
//
//

import UIKit
import FLAnimatedImage
import PureLayout

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
            imageView.autoPinEdgesToSuperviewEdges()
//        }


        blackGradientOverlay.autoPinEdge(toSuperviewEdge: .bottom)
        blackGradientOverlay.autoPinEdge(toSuperviewEdge: .left)
        blackGradientOverlay.autoPinEdge(toSuperviewEdge: .right)
        blackGradientOverlay.autoSetDimension(.height, toSize: 75)

        nameLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        nameLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 5)
        nameLabel.autoSetDimension(.width, toSize: UIApplication.shared.keyWindow!.frame.size.width / 2 - 30)

        priceLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 5)
        priceLabel.autoPinEdge(toSuperviewEdge: .right, withInset: 5)
        priceLabel.autoSetDimension(.width, toSize: 40)
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

        guard let this_url = URL(string: url) else { return }
        if this_url.absoluteString == "" { return }
        var image : UIImage?

        DispatchQueue.global(qos: .background).async {
            image = UIImage(data: NSData(contentsOf: this_url)! as Data)
            DispatchQueue.main.async {
                //guard row == self.tag else { return }
                self.imageView.alpha = 0
                self.imageView.image = UIImage.animatedImage(withAnimatedGIFURL: this_url)
                self.imageView.image = image

                UIView.animate(withDuration: 0.5, animations: {
                    self.imageView.alpha = 1
                })
            }
            completion?(true, image)
        }


    }
    
//    func setGif(url: String, completion: ((_ completed: Bool, _ image: UIImage?) -> ())?) {
////        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
////            completion?(completed: Bool(error == nil), image: image)
////            
////            dispatch_async(dispatch_get_main_queue()) {
////                self.imageView.image = image
////            }
////        }
//
//        guard let this_url = URL(string: url) else { return }
//        if this_url.absoluteString == "" { return }
//        let animatedImage : FLAnimatedImage?
//
//        DispatchQueue.global(qos: .background).async {
//            gif.animatedImage = FLAnimatedImage(animatedGIFData: NSData(contentsOf: this_url)! as Data)
//
//            DispatchQueue.main.async {
//                guard row == self.tag else { return }
//                self.gifView.alpha = 0
//                self.gifView.animatedImage = gif.animated_image
//
//                UIView.animate(withDuration: 0.5, animations: {
//                    self.gifView.alpha = 1
//                })
//                self.delegate?.cacheGif(gif: gif, row: row)
//            }
//        }
//    }

    fileprivate func setTitleText(_ name: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont.LatoBoldSmall(),
            NSForegroundColorAttributeName: UIColor.white,
            NSKernAttributeName: CGFloat(2.0)
        ]
        
        let attributedTitle = NSAttributedString(string: name.uppercased(), attributes: attributes as? [String : AnyObject])
        
        nameLabel.attributedText = attributedTitle
        nameLabel.sizeToFit()
    }
    
    fileprivate func setPrice(_ price: String) {
        let attributes: NSDictionary = [
            NSFontAttributeName: UIFont.LatoBoldSmall(),
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
