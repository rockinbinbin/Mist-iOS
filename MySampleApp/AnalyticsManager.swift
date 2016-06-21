//
//  AnalyticsManager.swift
//  Mist
//
//  Created by Steven on 6/20/16.
//
//

import Foundation
import AWSMobileAnalytics

class AnalyticsManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = AnalyticsManager()
    
    // MARK: - Event Recording
    
    /**
     Records a user interaction event.
     Note that this should not be a purchase. Purchases should be recorded with recordPurchase.
     
     - parameter event: The interaction event type.
     - parameter attributes: key-value pairs of strings to strings.
     - parameter metrics: key-value pairs of strings to numbers.
     */
    func recordEvent(event: AnalyticsEvent, attributes: [String : String] = [:], metrics: [String : NSNumber] = [:]) {
        
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let event = eventClient.createEventWithEventType(event.identifier)
        
        for key in attributes.keys {
            event.addAttribute(attributes[key], forKey: key)
        }
        
        for key in metrics.keys {
            event.addAttribute(String(metrics[key]), forKey: key)
        }
        
        eventClient.recordEvent(event)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            eventClient.submitEvents()
        })
    }
    
    func recordPurchase(product: Feed.Item, transactionId: String, quantity: Int = 1) {
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let eventBuilder = AWSMobileAnalyticsAppleMonetizationEventBuilder(eventClient: eventClient)
        
        eventBuilder.withProductId(product.id)
        eventBuilder.withItemPrice(Double(product.price)!, andPriceLocale: NSLocale(localeIdentifier: "en_US"))
        eventBuilder.withQuantity(quantity)
        eventBuilder.withTransactionId(transactionId)
        
        let event = eventBuilder.build()
        eventClient.recordEvent(event)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            eventClient.submitEvents()
        })
    }
}