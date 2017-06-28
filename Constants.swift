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
        //return UIFont(name: "Lato-Regular", size: 13)!
        return UIFont.systemFont(ofSize: 13)
    }
    class func LatoRegularMedium() -> UIFont {
        //return UIFont(name: "Lato-Regular", size: 18)!
        return UIFont.systemFont(ofSize: 18)
    }
    class func LatoBoldSmall() -> UIFont {
        //return UIFont(name: "Lato-Bold", size: 13)!
        return UIFont.boldSystemFont(ofSize: 13)
    }
    class func LatoBoldMedium() -> UIFont {
        //return UIFont(name: "Lato-Bold", size: 18)!
        return UIFont.boldSystemFont(ofSize: 18)
    }
    class func LatoLightItalicSmall() -> UIFont {
        //return UIFont(name: "Lato-LightItalic", size: 12)!
        return UIFont.systemFont(ofSize: 13)
    }
}

extension String {
    // Source: http://www.ietf.org/rfc/rfc3986.txt
    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    // Source: https://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
    func createSearchString() -> String? {
        let replaced = String(self.characters.map {
            $0 == " " ? "+" : $0
        })
        return replaced
    }
}

extension Dictionary {
    // Source: http://www.ietf.org/rfc/rfc3986.txt
    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        return parameterArray.joined(separator: "&")
    }
}
