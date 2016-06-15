//
//  FeedCell.swift
//  Mist
//
//  Created by Steven on 6/14/16.
//
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blackColor()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
}
