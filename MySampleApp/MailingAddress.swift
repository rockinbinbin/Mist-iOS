//
//  MailingAddress.swift
//  Facephoto
//
//  Created by Steven on 5/19/16.
//  Copyright © 2016 PluckPhoto. All rights reserved.
//

import UIKit
import AWSDynamoDB

private var currentAddress: MailingAddress? = nil

/// A mailing address.
class MailingAddress: NSObject {
    
    // MARK: - Model
    
    // Required
    let name: String
    let street: String
    let city: String
    let state: USState
    let zip: String
    
    // Optional
    let street2: String?
    let unit: String?
    
    // MARK: - Init
    
    convenience override init() {
        self.init(name: "", street: "", unit: "", city: "", state: .Michigan, zip: "")
    }
    
    init(name: String, street: String, street2: String? = nil, unit: String? = nil, city: String, state: USState, zip: String) {
        self.name = name
        self.street = street
        self.street2 = street2
        self.unit = unit
        self.city = city
        self.state = state
        self.zip = zip
        
        super.init()
    }
    
    class func loadAddressFromDynamoDB(emailIn: String?, completion: ((Bool) -> ())?) {
        
        var email: String
        
        if emailIn == nil {
            guard let userEmail = NSUserDefaults.standardUserDefaults().objectForKey("user_email") else {
                completion?(false)
                return
            }
            
            email = userEmail as! String
        } else {
            email = emailIn!
        }
        
        let attributeValue = AWSDynamoDBAttributeValue()
        attributeValue.S = email
        let condition = AWSDynamoDBCondition()
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        condition.attributeValueList = [attributeValue]
        
        let query = AWSDynamoDBQueryInput()
        query.tableName = "Address"
        query.keyConditions = ["username": condition]
        query.limit = 1

        AWSDynamoDB.defaultDynamoDB().query(query).continueWithBlock { (task: AWSTask) -> AnyObject? in
            guard let taskResult = task.result where (taskResult as! AWSDynamoDBQueryOutput).count! != 0 else {
                completion?(false)
                return nil
            }
            
            let result = ((taskResult as! AWSDynamoDBQueryOutput).items![0])
            
            let name: String = result["name"]!.S!
            let street: String = result["street"]!.S!
            let unit: String? = (result["unit"]!.S! == "null") ? "" : result["unit"]!.S!
            let city: String = result["city"]!.S!
            let state: USState = USState(abbreviation: result["state"]!.S!)!
            let zip: String = result["zip"]!.S!
            
            userAddress = MailingAddress(name: name, street: street, unit: unit, city: city, state: state, zip: zip)
            
            completion?(true)
            return nil
        }
    }
    
    static var userAddress: MailingAddress? = nil
    
    class func currentAddress() -> MailingAddress? {
        
        if userAddress != nil {
            return userAddress
        }
        
        let preferences = NSUserDefaults.standardUserDefaults()
        
        let name =              preferences.stringForKey("user_address_name")
        let streetAddress =     preferences.stringForKey("user_address_street")
        let unit =              preferences.stringForKey("user_address_unit")
        let city =              preferences.stringForKey("user_address_city")
        let stateAbbreviation = preferences.stringForKey("user_address_state")
        let zip =               preferences.stringForKey("user_address_zip")
        
        for addressComponent in [name, streetAddress, unit, city, stateAbbreviation, zip] {
            guard let component = addressComponent else {
                return nil
            }
            
            if component == "" {
                return nil
            }
        }
        
        return MailingAddress(name: name!, street: streetAddress!, unit: unit ?? nil, city: city!, state: USState(abbreviation: stateAbbreviation!)!, zip: zip!)
    }
    
    func saveAddress() -> Bool {
        if !isValid {
            return false
        }
        
        let preferences = NSUserDefaults.standardUserDefaults()
        
        preferences.setValue(name, forKey: "user_address_name")
        preferences.setValue(street, forKey: "user_address_street")
        preferences.setValue(unit, forKey: "user_address_unit")
        preferences.setValue(city, forKey: "user_address_city")
        preferences.setValue(state.abbreviation, forKey: "user_address_state")
        preferences.setValue(zip, forKey: "user_address_zip")
        
        MailingAddress.userAddress = self
        
        return true
    }
    
    var addressString: String {
        get {
            return "\(street)\(unit! != "" ? " \(unit!)" : ""), \(city), \(state.fullName) \(zip)"
        }
    }
    
    /// Addresses are valid if they fit they following two properties:
    /// * They have a valid zip code
    /// * None of the required nonoptional address components are empty
    var isValid: Bool {
        get {
            if !validZipCode(zip) {
                return false
            }
            
            for addressComponent in [name, street, city] {
                if addressComponent == "" {
                    return false
                }
            }
            
            return true
        }
    }
}

/// Validates a zip code string.
///
/// - Returns: Bool of whether or not the string is valid.
func validZipCode(zipCode: String) -> Bool {
    let zipRegex = "^\\d{5}(?:[-\\s]\\d{4})?$"
    
    do {
        let regex = try NSRegularExpression(pattern: zipRegex, options: [.CaseInsensitive])
        let result = regex.firstMatchInString(zipCode, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, zipCode.characters.count))
        
        if (result != nil) {
            return true
        }
    } catch {
        return false
    }
    
    return false
}
