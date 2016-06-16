//
//  LoadingView.swift
//  Mist
//
//  Created by Steven on 6/15/16.
//
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Singleton
    
    static let sharedInstance = LoadingView()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViewConstraints()
        backgroundColor = .whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    private lazy var logo: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Loading-Logo"))
        self.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Layout
    
    var logoSizeConstraint: (width: NSLayoutConstraint, height: NSLayoutConstraint)? = nil
    
    func setViewConstraints() {
        logo.centerInSuperview()
        logoSizeConstraint = logo.sizeToWidthAndHeight(100)
    }
    
    // MARK: - Visibility
    
    func hideView(completion: (() -> ())? = nil) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.logoSizeConstraint?.width.constant = 200
            self.logoSizeConstraint?.height.constant = 200
            
            UIView.animateWithDuration(0.25, animations: {
                self.logo.layer.opacity = 0.0
                self.layer.opacity = 0.0
                self.layoutIfNeeded()
            }) { (Bool) in
                dispatch_async(dispatch_get_main_queue()) {
                    LoadingView.sharedInstance.removeFromSuperview()
                    completion?()
                }
            }
        }
    }
}
