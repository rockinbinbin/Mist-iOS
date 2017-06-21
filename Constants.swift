//
//  Constants.swift
//  Mist
//
//  Created by Steven on 6/18/15.
//  Copyright (c) 2015 Bounce Labs, Inc. All rights reserved.
//

import UIKit

public extension UIColor {
    class func DoneBlue() -> UIColor {
        return UIColor(red: 75/255.0, green: 125/255.0, blue: 219/255.0, alpha: 1.0)
    }
    class func DarkBlue() -> UIColor {
        return UIColor(red:0.09, green:0.26, blue:0.34, alpha:1.0)
    }
    class func BuyBlue() -> UIColor {
        return UIColor(red:0, green:122/255.0, blue:1, alpha:1)
    }
    class func PrettyBlue() -> UIColor {
        return UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
    }
    class func DarkGray() -> UIColor {
        return UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.0)
    }
}

public extension UIFont {
    class func LatoRegularSmall() -> UIFont {
        return UIFont(name: "Lato-Regular", size: 13)!
    }
    class func LatoRegularMedium() -> UIFont {
        return UIFont(name: "Lato-Regular", size: 18)!
    }
    class func LatoBoldSmall() -> UIFont {
        return UIFont(name: "Lato-Bold", size: 13)!
    }
    class func LatoBoldMedium() -> UIFont {
        return UIFont(name: "Lato-Bold", size: 18)!
    }
    class func LatoLightItalicSmall() -> UIFont {
        return UIFont(name: "Lato-LightItalic", size: 12)!
    }
}
