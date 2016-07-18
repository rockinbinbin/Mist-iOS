//
//  Feed.swift
//  Mist
//
//  Created by Steven on 6/17/16.
//
//

import Foundation
import AWSMobileHubHelper

/**
 The manager for loading and storing the feed.
 */
class Feed {
    
    // MARK: - Singleton
    
    static let sharedInstance = Feed()
    
    // MARK: - Model
    
    private lazy var _items: [Item] = []
    
    var items: [Item] {
        get {
            var items: [Item] = []
            originalIndices = []
            
            for (index, item) in _items.enumerate() {
                if item.validWithFilters {
                    originalIndices.append(index)
                    items.append(item)
                }
            }
            
            return items
        }
    }
    
    private var originalIndices: [Int] = []
    
    func sizeAtIndex(index: Int) -> CGSize {
        return _items[originalIndices[index]].size ?? CGSizeMake(500, 250)
    }
    
    func setSize(size: CGSize, atIndex index: Int) {
        _items[index].size = size
    }
    
    // MARK: - Loading
    
    /**
     Loads the feed, and calls the completion block after.
     If this call is successful, Feed.sharedInstance.items will contain the feed.
     
     - parameter completion: Completion handler.
     */
    func loadFeed(completion: ((NSError?) -> ())?) {
        AWSCloudLogic.defaultCloudLogic().invokeFunction("GenerateFeed", withParameters: nil) { (result: AnyObject?, error: NSError?) in
            
            defer {
                completion?(error)
            }
            
            guard error == nil else {
                return
            }
            
            guard let rawFeed = (result as? NSDictionary)?["items"] as? [NSDictionary] else {
                print("ERROR: Feed loaded but was not of the correct form.")
                return
            }
            
            for productDictionary in rawFeed {
                self._items.append(Item(dictionary: productDictionary)!)
            }
        }
    }
    
    // MARK: - Classes
    
    /**
     The basic unit of data for a feed. Should map one-to-one with data returned from Lambda:GenerateFeed.
     */
    struct Item {
        let brand: String
        let imageURLs: [String]
        let name: String
        let price: String
        let id: String
        let description: String
        let categories: [Feed.Filter.Category] = []
        var size: CGSize? = nil
        
        var imageURL: String {
            get {
                return imageURLs[0]
            }
        }
        
        init?(dictionary: NSDictionary) {
            
            guard
                let brand = dictionary["Brand"] as? String,
                let imageURLs = dictionary["ImageURLs"] as? [String],
                let name = dictionary["ItemName"] as? String,
                let id = dictionary["ID"] as? String,
                let description = dictionary["Description"] as? String,
                let price = dictionary["Price"] as? String else {
                    return nil
            }
            
            self.brand = brand
            self.imageURLs = imageURLs
            self.name = name
            self.price = price
            self.id = id
            self.description = description
        }
        
        /**
         Returns true if at least one of the filters are satisfied from each type of filter.
         */
        var validWithFilters: Bool {
            
            var satisfied = (categories: false, price: false)
            
            let categoryFilters = Feed.Filters.sharedInstance.categories
            let priceFilters = Feed.Filters.sharedInstance.price
            
            if Array(categoryFilters.values).contains(true) {
                for category in categories {
                    if categoryFilters[category]! {
                        satisfied.categories = true
                    }
                }
            } else {
                satisfied.categories = true
            }
            
            // If no price filters are set, price filter is satisfied.
            if Array(priceFilters.values).contains(true) {
                let priceFilter = Feed.Filter.Price(price: Double(price)!)!
                satisfied.price = priceFilters[priceFilter]!
            } else {
                satisfied.price = true
            }
            
            return satisfied.price && satisfied.categories
        }
    }
}