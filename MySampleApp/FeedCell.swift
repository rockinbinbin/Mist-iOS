//
//  FeedCell.swift
//  Mist
//
//  Created by Steven on 6/14/16.
//
//

import UIKit
import SDWebImage

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
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
        imageView.pinToEdgesOfSuperview()
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    func setImage(url: NSURL, completion: ((completed: Bool) -> ())?) {
        imageView.sd_setImageWithURL(url) { (image, error, cacheType, url) in
            completion?(completed: Bool(error == nil))
        }
    }
    
    // MARK: - Interface
    
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
}
