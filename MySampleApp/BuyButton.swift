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
        self.backgroundColor = UIColor.clearColor()
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
    
    private func formatTitle(newPriceValue: Float) {
        var title: String
        
        // If a whole value price
        if (newPriceValue % 1 == 0) {
            title = "BUY for $\(Int(newPriceValue))"
        } else {
            title = String(format: "BUY for $%.2f", newPriceValue)
        }
        
        let attrString = NSMutableAttributedString(string: title)
        
        // Customize title string
        var offset = 0
        attrString.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 14)!], range: NSMakeRange(0, "BUY".length))
        offset += "BUY".length
        attrString.addAttributes([NSFontAttributeName: UIFont(name: "Lato-LightItalic", size: 12)!], range: NSMakeRange(offset, " for ".length))
        offset += " for ".length
        attrString.addAttributes([NSFontAttributeName: UIFont(name: "Lato-Bold", size: 14)!], range: NSMakeRange(offset, title.characters.count - offset))
        
        attrString.addAttributes([NSKernAttributeName: 1.5], range: NSMakeRange(0, title.characters.count))

        attrString.addAttributes([NSForegroundColorAttributeName: UIColor.lightGrayColor()], range: NSMakeRange(0, title.characters.count))
        setAttributedTitle(attrString, forState: .Selected)
        
        let normalAttrString = attrString
        normalAttrString.addAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], range: NSMakeRange(0, title.characters.count))
        setAttributedTitle(normalAttrString, forState: .Normal)
    }
}