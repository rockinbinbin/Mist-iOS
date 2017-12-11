/**
 * A bar button item in the top of the feed.
 */

import UIKit

open class ProductBarButtonItem: UIBarButtonItem {
    
    /**
     * Initializes the bar button item.
     * - Parameter title: Title of the button
     * - Parameter actionTarget: Target of the button
     * - Parameter actionSelector: Selector of the button
     */
    init(title: String, actionTarget: AnyObject?, actionSelector: Selector?, buttonColor: UIColor? = UIColor.black) {
        super.init()
        
        let buttonString = title.uppercased()
        let attributedBarButtonBackStr = NSMutableAttributedString(string: buttonString as String)
        
        attributedBarButtonBackStr.addAttribute(NSFontAttributeName,
                                                value: UIFont.LatoRegularSmall(),
                                                range: NSRange(location:0, length: title.count))
        
        attributedBarButtonBackStr.addAttribute(NSKernAttributeName,
                                                value: 3.0,
                                                range: NSRange(location:0, length: title.count))
        
        attributedBarButtonBackStr.addAttribute(NSForegroundColorAttributeName,
                                                value: buttonColor!,
                                                range: NSRange(location:0, length: title.count))
        
        let button = UIButton()
        button.setAttributedTitle(attributedBarButtonBackStr, for: UIControlState())
        button.sizeToFit()
        button.addTarget(actionTarget, action: (actionSelector ?? nil)!, for: .touchUpInside)
        
        self.customView = button
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
