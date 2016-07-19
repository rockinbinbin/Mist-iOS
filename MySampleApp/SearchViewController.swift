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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .blackColor()
        
        navigationController?.navigationBar.tintColor = .blackColor()
        
        navigationItem.titleView = searchField
        
        addTapGestureRecognizer()
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
    
    private lazy var searchField: UITextField = {
        let field: UITextField = UITextField(frame: CGRectMake(-40, 0, self.navigationController!.navigationBar.frame.size.width, 21))
        field.font = UIFont(name: "Lato-Regular", size: 15)
        field.placeholder = "Search by product, brand, and more"
        return field
    }()
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        
        super.updateViewConstraints()
    }
    
    // MARK: - Navigation
    
    func dismiss() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.shouldResignFirstResponder))
        view.addGestureRecognizer(tap)
    }
    
    func shouldResignFirstResponder() {
        searchField.resignFirstResponder()
    }
}
