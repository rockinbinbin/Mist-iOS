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
    
    func setImage(url: String, completion: ((completed: Bool) -> ())?) {
        DLImageLoader.sharedInstance.imageFromUrl(url) { (error, image) in
            completion?(completed: Bool(error == nil))
            
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.image = image
            }
        }
    }
    
    // MARK: - Interface
    
    var image: UIImage? {
        get {
            return imageView.image
        }
    }
}
