//
//  AddCreditCardViewController.swift
//  Mist
//
//  Created by Steven on 8/4/16.
//
//

import UIKit

class AddCreditCardViewController: UIViewController {
    
    convenience init(backgroundImage: UIImage) {
        self.init()
        
        backgroundImageView.image = backgroundImage
        
//        navigationController?.navigationBar.backgroundColor = UIColor(white: 0.44, alpha: 1)
        UINavigationBar.appearance().backgroundColor = UIColor(white: 0.44, alpha: 1)
        let doneButton = ProductBarButtonItem(title: "Cancel", actionTarget: self, actionSelector: #selector(cancelPressed), buttonColor: UIColor.whiteColor())
        navigationItem.leftBarButtonItem = doneButton
        
        view.setNeedsUpdateConstraints()
    }
    
    // MARK: - UI Components
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIApplication.sharedApplication().keyWindow!.frame
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        imageView.addSubview(blurEffectView)
        
        self.view.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        backgroundImageView.pinToEdgesOfSuperview()
    }
    
    // MARK: - Navigation
    
    func cancelPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Status Bar
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }
}
