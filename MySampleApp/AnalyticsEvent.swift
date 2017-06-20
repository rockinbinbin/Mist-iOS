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
        case itemCellPressed
        case accountPressed
        case searchPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.replacingOccurrences(of: "Mist.Event.", with: "")
            }
        }
    }
    
    enum Account: AnalyticsEvent {
        case paymentMethodPressed
        case shippingAddressPressed
        case contactUsPressed
        
        case logOutPressed
        case signInPressed
        case signUpPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.replacingOccurrences(of: "Mist.Event.", with: "")
            }
        }
    }
    
    enum Product: AnalyticsEvent {
        case buyPressed
        
        var identifier: String {
            get {
                let reflection = String(reflecting: self)
                return reflection.replacingOccurrences(of: "Mist.Event.", with: "")
            }
        }
    }
}
