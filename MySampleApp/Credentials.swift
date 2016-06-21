//
//  Credentials.swift
//  Mist
//
//  Created by Steven on 6/17/16.
//
//

import Foundation

let _stripePublishableKey = "pk_test_yQLOuYjBE0aXvcbG2wHOoYDP"

@objc class Credentials: NSObject {
    
    // MARK: - Stripe
    class func stripePublishableKey() -> String { return _stripePublishableKey }
}