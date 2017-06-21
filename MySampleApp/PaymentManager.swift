////
////  PaymentManager.swift
////  Mist
////
////  Created by Steven on 6/17/16.
////
////
//
//import Foundation
//import Stripe
//
//class PaymentManager {
//    
//    // MARK: - Singleton
//    
//    static let sharedInstance = PaymentManager()
//    
//    // MARK: - Constants
//    
//    let appleMerchantId = "merchant.com.Mist"
//    
//    /**
//     Attempts to generate the PKPaymentRequest object for the given product.
//     Configures the PKPaymentRequest object to include all shipping address fields.
//     
//     - parameter product: The item to purchase
//     - throws: If the payment request was not valid
//     - returns: A valid PKPaymentRequest object, or nil if the device is not able to use Apple Pay.
//     */
//    func generatePaymentRequest(_ product: Feed.Item) throws -> PKPaymentRequest? {
//        guard appleMerchantId.characters.count != 0 else {
//            throw Error.merchantIDNotSet
//        }
//        
//        guard let paymentRequest = Stripe.paymentRequest(withMerchantIdentifier: appleMerchantId) else {
//            throw Error.couldNotFormRequest
//        }
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .decimal
//        
//        guard let priceDecimalValue = numberFormatter.number(from: product.price)?.decimalValue else {
//            throw Error.invalidPrice
//        }
//        
//        let price = NSDecimalNumber(decimal: priceDecimalValue)
//        
//        // TODO: Figure out actual shipping cost
//        let shipping = NSDecimalNumber(value: 5.0 as Double)
//        let total = price.adding(shipping)
//        
//        paymentRequest.paymentSummaryItems = [
//            PKPaymentSummaryItem(label: product.name, amount: price),
//            PKPaymentSummaryItem(label: "Shipping", amount: shipping),
//            PKPaymentSummaryItem(label: "Mist", amount: total)
//        ]
//        
//        paymentRequest.requiredShippingAddressFields = .all
//        
//        // If the current device support Apple Pay, it is a valid outcome
//        guard Stripe.canSubmitPaymentRequest(paymentRequest) else {
//            return nil
//        }
//        
//        return paymentRequest
//    }
//    
//    // MARK: - Error Handling
//    
//    enum Error: Error {
//        case merchantIDNotSet
//        case couldNotFormRequest
//        case invalidPrice
//    }
//}
