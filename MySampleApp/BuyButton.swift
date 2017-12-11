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
    
    fileprivate func formatTitle(_ price: Float) {
        var title: String

        // If a whole value price
        if (price.truncatingRemainder(dividingBy: 1) == 0) {
            title = "BUY for $\(Int(Double(price)/100.0))"
        } else {
            title = String(format: "BUY for $%.2f", 5.0)
        }
        
        let attrString = NSMutableAttributedString(string: title)
        
        // Customize title string
        var offset = 0
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.LatoBoldSmall()], range: NSMakeRange(0, "BUY".count))
        offset += "BUY".count
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.LatoLightItalicSmall()], range: NSMakeRange(offset, " for ".count))
        offset += " for ".count
        attrString.addAttributes([NSAttributedStringKey.font: UIFont.LatoBoldSmall()], range: NSMakeRange(offset, title.count - offset))
        
        attrString.addAttributes([NSAttributedStringKey.kern: 1.5], range: NSMakeRange(0, title.count))

        attrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.lightGray], range: NSMakeRange(0, title.count))
        setAttributedTitle(attrString, for: .selected)
        
        let normalAttrString = attrString
        normalAttrString.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], range: NSMakeRange(0, title.count))
        setAttributedTitle(normalAttrString, for: UIControlState())
    }
}
