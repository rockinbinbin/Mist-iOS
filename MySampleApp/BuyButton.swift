//
//  BuyButton.swift
//  Mist
//
//  Created by Steven on 3/6/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit

class BuyButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.price = 0
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("BuyButton does not have init?(coder) implemented.")
    }
    
    // MARK: - Model
    
    var _price: Float = 0
    
    var price: Float {
        get {
            return _price
        }
        
        set {
            _price = price
            formatTitle(newValue)
        }
    }
    
    // MARK: - Appearance
    
    fileprivate func formatTitle(_ newPriceValue: Float) {
        var title: String
        
        // If a whole value price
        if (newPriceValue.truncatingRemainder(dividingBy: 1) == 0) {
            title = "BUY for $\(Int(newPriceValue))"
        } else {
            title = String(format: "BUY for $%.2f", 5.0)
        }
        
        let attrString = NSMutableAttributedString(string: title)
        
        // Customize title string
        var offset = 0
        attrString.addAttributes([NSFontAttributeName: UIFont.LatoBoldSmall()], range: NSMakeRange(0, "BUY".characters.count))
        offset += "BUY".characters.count
        attrString.addAttributes([NSFontAttributeName: UIFont.LatoLightItalicSmall()], range: NSMakeRange(offset, " for ".characters.count))
        offset += " for ".characters.count
        attrString.addAttributes([NSFontAttributeName: UIFont.LatoBoldSmall()], range: NSMakeRange(offset, title.characters.count - offset))
        
        attrString.addAttributes([NSKernAttributeName: 1.5], range: NSMakeRange(0, title.characters.count))

        attrString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGray], range: NSMakeRange(0, title.characters.count))
        setAttributedTitle(attrString, for: .selected)
        
        let normalAttrString = attrString
        normalAttrString.addAttributes([NSForegroundColorAttributeName: UIColor.white], range: NSMakeRange(0, title.characters.count))
        setAttributedTitle(normalAttrString, for: UIControlState())
    }
}
