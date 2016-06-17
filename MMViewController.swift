//
//  MMViewController.swift
//  Mist
//
//  Created by Steven on 6/17/16.
//
//

import UIKit

/**
 The superclass which handles navigation bar customization for Mist view controllers.
 */
class MMViewController: UIViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.backgroundColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
    }
    
    var mistLogoInTitle: Bool = false {
        didSet {
            if mistLogoInTitle {
                navigationItem.titleView = UIImageView(image: UIImage(named: "Products-Mist-Logo"))
            }
        }
    }
    
    // MARK: - Navigation Bar Buttons
    
    func setLeftButton(title: String, target: AnyObject?, selector: Selector?) {
        navigationItem.leftBarButtonItem = ProductBarButtonItem(title: title, actionTarget: target, actionSelector: selector)
    }
    
    func setRightButton(title: String, target: AnyObject?, selector: Selector?) {
        navigationItem.rightBarButtonItem = ProductBarButtonItem(title: title, actionTarget: target, actionSelector: selector)
    }
    
    /**
     A bar button item in the top of the feed.
     */
    class ProductBarButtonItem: UIBarButtonItem {
        
        /**
         Initializes the bar button item.
         
         - Parameter title: Title of the button
         - Parameter actionTarget: Target of the button
         - Parameter actionSelector: Selector of the button
         */
        init(title: String, actionTarget: AnyObject?, actionSelector: Selector?, buttonColor: UIColor? = UIColor.blackColor()) {
            super.init()
            
            let buttonString = title.uppercaseString
            let attributedBarButtonBackStr = NSMutableAttributedString(string: buttonString as String)
            
            attributedBarButtonBackStr.addAttribute(NSFontAttributeName,
                                                    value: UIFont(name: "Lato-Regular", size: 13.0)!,
                                                    range: NSRange(location:0, length: title.characters.count))
            
            attributedBarButtonBackStr.addAttribute(NSKernAttributeName,
                                                    value: 3.0,
                                                    range: NSRange(location:0, length: title.characters.count))
            
            attributedBarButtonBackStr.addAttribute(NSForegroundColorAttributeName,
                                                    value: buttonColor!,
                                                    range: NSRange(location:0, length: title.characters.count))
            
            let button = UIButton()
            button.setAttributedTitle(attributedBarButtonBackStr, forState: .Normal)
            button.sizeToFit()
            button.addTarget(actionTarget, action: actionSelector ?? nil, forControlEvents: .TouchUpInside)
            
            self.customView = button
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}