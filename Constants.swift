//
//  Constants.swift
//  Mist
//
//  Created by Steven on 6/18/15.
//  Copyright (c) 2015 Bounce Labs, Inc. All rights reserved.
//

import UIKit

struct Constants {
    static let baseURL = "http://127.0.0.1:5000/api/"
}

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
        return UIFont(name: "Lato-Light", size: 12)!
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

extension UICollectionView {
    func configureCollectionView() {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "GradientSunrise")!)
        self.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
        self.register(FeedCell.self, forCellWithReuseIdentifier: "cell")
    }
}

//extension UINavigationBar {
//    func styleNavBar() {
//        self.barTintColor = UIColor.white
//        self.isTranslucent = false
//        self.clipsToBounds = false
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1.0
//        self.layer.shadowRadius = 0.0
//    }
//}
//
//extension UINavigationItem {
//    func styleTitleView(str: String) {
//        let titleLabel = UILabel()
//        let attributes: NSDictionary = [
//            NSFontAttributeName: UIFont.LatoBoldMedium(),
//            NSForegroundColorAttributeName: UIColor.PrettyBlue(),
//            NSKernAttributeName: CGFloat(5)
//        ]
//        let attributedTitle = NSAttributedString(string: str, attributes: attributes as? [String : AnyObject])
//        titleLabel.attributedText = attributedTitle
//        titleLabel.sizeToFit()
//        self.titleView = titleLabel
//    }
//}

