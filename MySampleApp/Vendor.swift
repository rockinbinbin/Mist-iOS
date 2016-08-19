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

public class VendorObj: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    public static func hashKeyAttribute() -> String {
        return "ID"
    }
    
    public static func dynamoDBTableName() -> String {
        return "vendor"
    }
    
    var brand = String()
    var products = NSMutableSet()
    var shortDescription = String()
    var id = String()
}

public protocol loadedVendorDelegate {
    func passVendor(vendor: VendorObj)
}

/**
 The manager for loading vendor info.
 */
public class VendorClass {

    var loadVendorDelegate : loadedVendorDelegate? = nil
    
    static let sharedInstance = VendorClass()
    var vendors: [Vendor] = []
    
    let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.defaultDynamoDBObjectMapper()
    
    var items: [Vendor] {
        get {
            var vendors: [Vendor] = []
            for (index, vendor) in vendors.enumerate() {
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
    
    func loadVendorFromID(id: String, completion: ((NSError?) -> ())?) {
        
        let vendor = VendorObj()
        
        dynamoDBObjectMapper.load(VendorObj.self, hashKey: id, rangeKey: nil).continueWithBlock { (task: AWSTask) -> AnyObject? in
            
            guard let result = task.result else {
                print(task.exception)
                print(task.error)
                return nil
            }
            
            vendor.brand = result.valueForKey("Brand") as! String
            vendor.id = result.valueForKey("ID") as! String
            vendor.products = result.valueForKey("products") as! NSMutableSet
            vendor.shortDescription = result.valueForKey("ShortDescrioption") as! String
            
            guard let delegate = self.loadVendorDelegate else {
                return VendorObj()
            }
            delegate.passVendor(vendor)
            return vendor
        }
    }
    
    func loadVendorFromProductName(name: String, completion: ((NSError?) -> ())?) {
        
        let vendor = VendorObj()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.exclusiveStartKey = nil
        scanExpression.limit = 5
        let condition = AWSDynamoDBCondition()
        let attribute = AWSDynamoDBAttributeValue()
        attribute.N = name
        condition.attributeValueList = [attribute]
        condition.comparisonOperator = AWSDynamoDBComparisonOperator.EQ
        
        dynamoDBObjectMapper.scan(VendorObj.self, expression: scanExpression) { (result: AWSDynamoDBPaginatedOutput?, error: NSError?) in
            
            guard let result = result else {
                print (error)
                return
            }
            print (result)
            vendor.brand = result.valueForKey("Brand") as! String
            vendor.id = result.valueForKey("ID") as! String
            vendor.products = result.valueForKey("products") as! NSMutableSet
            vendor.shortDescription = result.valueForKey("ShortDescrioption") as! String
            
            // Class must have this method implemented
            guard let delegate = self.loadVendorDelegate else {
                return
            }
            delegate.passVendor(vendor)
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




