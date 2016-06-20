//
//  Credentials.swift
//  Mist
//
//  Created by Steven on 6/17/16.
//
//

import Foundation

let _stripePublishableKey = "sk_test_0Ez2nUaP3AFDtidBQMANhp2S"

@objc class Credentials: NSObject {
    
    // MARK: - Stripe
    class func stripePublishableKey() -> String { return _stripePublishableKey }
}