//
//  AnalyticsEvent.swift
//  Mist
//
//  Created by Steven on 6/20/16.
//
//

import Foundation

// MARK: - Event Types

protocol AnalyticsEvent {
    /**
     A unique string representing the event.
     */
    var identifier: String { get }
}

/**
 An event to be logged in AWS Mobile Analytics.
 
 Note: For creating future events, make sure the nested enum conforms
 to AnalyticsEvent by reusing the code for var identifier: String.
 */
enum Event {
    
    enum Feed: AnalyticsEvent {
        case ItemCellPressed
        case AccountPressed
        case SearchPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.stringByReplacingOccurrencesOfString("Mist.Event.", withString: "")
            }
        }
    }
    
    enum Account: AnalyticsEvent {
        case PaymentMethodPressed
        case ShippingAddressPressed
        case ContactUsPressed
        
        case LogOutPressed
        case SignInPressed
        case SignUpPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.stringByReplacingOccurrencesOfString("Mist.Event.", withString: "")
            }
        }
    }
    
    enum Product: AnalyticsEvent {
        case BuyPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.stringByReplacingOccurrencesOfString("Mist.Event.", withString: "")
            }
        }
    }
}