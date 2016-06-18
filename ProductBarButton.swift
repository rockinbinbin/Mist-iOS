/**
 * A bar button item in the top of the feed.
 */

import UIKit

public class ProductBarButtonItem: UIBarButtonItem {
    
    /**
     * Initializes the bar button item.
     * - Parameter title: Title of the button
     * - Parameter actionTarget: Target of the button
     * - Parameter actionSelector: Selector of the button
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
