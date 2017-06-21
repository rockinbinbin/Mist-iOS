//
//  Vendor.swift
//  Mist
//
//  Created by Robin Mehta on 8/10/16.
//
//

import Foundation
import AWSMobileHubHelper
import AWSDynamoDB

open class VendorObj: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    open static func hashKeyAttribute() -> String {
        return "ID"
    }
    
    open static func dynamoDBTableName() -> String {
        return "vendor"
    }
    
    var brand = String()
    var products = NSMutableSet()
    var shortDescription = String()
    var id = String()
}

public protocol loadedVendorDelegate {
    func passVendor(_ vendor: VendorObj)
}

/**
 The manager for loading vendor info.
 */
open class VendorClass {

    var loadVendorDelegate : loadedVendorDelegate? = nil
    
    static let sharedInstance = VendorClass()
    var vendors: [Vendor] = []
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
    
    var items: [Vendor] {
        get {
            var vendors: [Vendor] = []
            for (index, vendor) in vendors.enumerated() {
                vendors.append(vendor)
            }
            //print(vendors)
            return vendors
        }
    }
    
    var searchItems: [Vendor] {
        get {
            return vendors
        }
    }
    
    func loadVendorFromID(_ id: String, completion: ((NSError?) -> ())?) {
        
        let vendor = VendorObj()
        
        dynamoDBObjectMapper.load(VendorObj.self, hashKey: id, rangeKey: nil).continue({ (task: AWSTask) -> AnyObject? in
            
            guard let result = task.result else {
                print(task.exception)
                print(task.error)
                return nil
            }
            
            vendor?.brand = result.value(forKey: "Brand") as! String
            vendor?.id = result.value(forKey: "ID") as! String
            vendor?.products = result.value(forKey: "products") as! NSMutableSet
            vendor?.shortDescription = result.value(forKey: "ShortDescrioption") as! String
            
            guard let delegate = self.loadVendorDelegate else {
                return VendorObj()
            }
            delegate.passVendor(vendor!)
            return vendor
        })
    }
    
    func loadVendorFromProductName(_ name: String, completion: ((NSError?) -> ())?) {
        
        let vendor = VendorObj()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.exclusiveStartKey = nil
        scanExpression.limit = 5
        let condition = AWSDynamoDBCondition()
        let attribute = AWSDynamoDBAttributeValue()
        attribute?.n = name
        condition?.attributeValueList = [attribute!]
        condition?.comparisonOperator = AWSDynamoDBComparisonOperator.EQ

        dynamoDBObjectMapper.scan(VendorObj.self, expression: scanExpression) { (result: AWSDynamoDBPaginatedOutput?, error: Error?) in
            
            guard let result = result else {
                print (error)
                return
            }
            print (result)
            vendor?.brand = result.value(forKey: "Brand") as! String
            vendor?.id = result.value(forKey: "ID") as! String
            vendor?.products = result.value(forKey: "products") as! NSMutableSet
            vendor?.shortDescription = result.value(forKey: "ShortDescrioption") as! String
            
            // Class must have this method implemented
            guard let delegate = self.loadVendorDelegate else {
                return
            }
            delegate.passVendor(vendor!)
        }
    }
    
    // MARK: - Classes
    
    /**
     The basic unit of a vendor.
     */
    struct Vendor {
        let brand: String
        let products: NSMutableSet
        let shortDescription: String
        let id: String
        
        init?(dictionary: NSDictionary) {
            
            guard let brand = dictionary["Brand"] as? String else {
                print("The vendor's brand was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let shortDescription = dictionary["ShortDescription"] as? String else {
                print("The vendor's name was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let id = dictionary["ID"] as? String else {
                print("The vendor's id was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let products = dictionary["products"] as? NSMutableSet else {
                print ("The vendor's products were incorrect.")
                print (dictionary)
                return nil
            }
            
            self.brand = brand
            self.shortDescription = shortDescription
            self.id = id
            self.products = products // An NSMutableSet of product IDs.
        }
    }
}




