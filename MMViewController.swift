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
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    var mistLogoInTitle: Bool = false {
        didSet {
            if mistLogoInTitle {
                navigationItem.titleView = UIImageView(image: UIImage(named: "Products-Mist-Logo"))
            }
        }
    }
    
    // MARK: - Navigation Bar Buttons
    
    func setLeftButton(_ title: String, target: AnyObject?, selector: Selector?) {
        navigationItem.leftBarButtonItem = ProductBarButtonItem(title: title, actionTarget: target, actionSelector: selector)
    }
    
    func setRightButton(_ title: String, target: AnyObject?, selector: Selector?) {
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
        init(title: String, actionTarget: AnyObject?, actionSelector: Selector?, buttonColor: UIColor? = UIColor.black) {
            super.init()
            
            let buttonString = title.uppercased()
            let attributedBarButtonBackStr = NSMutableAttributedString(string: buttonString as String)

            attributedBarButtonBackStr.addAttribute(NSAttributedStringKey.font,
                                                    value: UIFont.LatoBoldSmall(),
                                                    range: NSRange(location:0, length: title.count))

            attributedBarButtonBackStr.addAttribute(NSAttributedStringKey.kern,
                                                    value: 3.0,
                                                    range: NSRange(location:0, length: title.count))
            
            attributedBarButtonBackStr.addAttribute(NSAttributedStringKey.foregroundColor,
                                                    value: buttonColor!,
                                                    range: NSRange(location:0, length: title.count))
            
            let button = UIButton()
            button.setAttributedTitle(attributedBarButtonBackStr, for: UIControlState())
            button.sizeToFit()
            button.addTarget(actionTarget, action: (actionSelector ?? nil)!, for: .touchUpInside)
            
            self.customView = button
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}
