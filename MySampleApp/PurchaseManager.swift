//
//  PurchaseManager.swift
//  Mist
//
//  Created by Steven on 8/3/16.
//
//

import UIKit
import Stripe

class PurchaseManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = PurchaseManager()
    
    // MARK: - Init
    
    var deviceSupportsApplePay: Bool {
        get {
            return Stripe.deviceSupportsApplePay()
        }
    }
    
    var deviceSupportsApplePayShippingAddress: Bool {
        get {
            guard #available(iOS 9, *) else {
                return false
            }
            
            return deviceSupportsApplePay
        }
    }
    
    func recordPurchase(purchase: String) {
        print(purchase)
    }
}

