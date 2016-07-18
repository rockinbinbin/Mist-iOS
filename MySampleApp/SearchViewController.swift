//
//  SearchViewController.swift
//  Mist
//
//  Created by Steven on 7/18/16.
//
//

import UIKit

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundGradient()
        
        view.backgroundColor = .whiteColor()
        view.setNeedsUpdateConstraints()
        
//        let backImage = UIImage(named: "Search-Back")!.imageWithRenderingMode(.AlwaysOriginal)
//        let barButtonItem = UIBarButtonItem(image: backImage, style: .Plain, target: self, action: #selector(SearchViewController.dismiss))
//        
//        navigationItem.backBarButtonItem = barButtonItem
//        navigationController!.navigationBar.backIndicatorImage = backImage
//        navigationController!.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .blackColor()
        
        navigationController?.navigationBar.tintColor = .blackColor()
    }
    
    // MARK: - Appearance
    
    /**
     Creates a subtle gradient in the background layer.
     */
    func setBackgroundGradient() {
        let overlayView = UIView(frame: view.bounds)
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = overlayView.bounds
        gradient.colors = [UIColor.whiteColor(), UIColor(white: 0, alpha: 1.0)]
        
        overlayView.layer.insertSublayer(gradient, atIndex: 0)
        view.addSubview(overlayView)
    }
    
    // MARK: - UI Components
    
    
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
