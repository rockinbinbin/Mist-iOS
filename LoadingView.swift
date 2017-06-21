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
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Components
    
    fileprivate lazy var logo: UIImageView = {
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
    
    var hasHiddenOnce: Bool = false
    
    func hideView(_ completion: (() -> ())? = nil) {
        
        DispatchQueue.main.async {
            self.logoSizeConstraint?.width.constant = 200
            self.logoSizeConstraint?.height.constant = 200
            
            UIView.animate(withDuration: 0.25, animations: {
                self.logo.layer.opacity = 0.0
                self.layer.opacity = 0.0
                self.layoutIfNeeded()
            }, completion: { (Bool) in
                DispatchQueue.main.async {
                    LoadingView.sharedInstance.removeFromSuperview()
                    completion?()
                }
            }) 
        }
    }
}
