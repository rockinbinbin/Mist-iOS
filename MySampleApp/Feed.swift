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
    
    fileprivate lazy var _items: [Item] = []
    
    var items: [Item] {
        get {
            var items: [Item] = []
            originalIndices = []
            
            for (index, item) in _items.enumerated() {
                if item.validWithFilters && item.show {
                    originalIndices.append(index)
                    items.append(item)
                }
            }
            
            return items
        }
    }
    
    var searchItems: [Item] {
        get {
            return _items
        }
    }
    
    fileprivate var originalIndices: [Int] = []
    
    func sizeAtIndex(_ index: Int) -> CGSize {
        //print("\(index): \(originalIndices[index]), size: \(_items[originalIndices[index]].name)")
        
        return _items[originalIndices[index]].size ?? CGSize(width: 500, height: 10)
    }
    
    func setSize(_ size: CGSize, atIndex index: Int) {
        _items[index].size = size
    }
    
    // MARK: - Loading
    
    /**
     Loads the feed, and calls the completion block after.
     If this call is successful, Feed.sharedInstance.items will contain the feed.
     
     - parameter completion: Completion handler.
     */
    func loadFeed(_ completion: ((NSError?) -> ())?) {
//        AWSCloudLogic.default().invokeFunction("GenerateFeed", withParameters: nil) { (result: Any, error: Error) in
//            defer {
//                completion?(error as NSError)
//            }
//            
//            guard error == nil else {
//                return
//            }
//            
//            guard let rawFeed = (result as? NSDictionary)?["items"] as? [NSDictionary] else {
//                print("ERROR: Feed loaded but was not of the correct form.")
//                return
//            }
//            
//            for productDictionary in rawFeed {
//                if let dict = Item(dictionary: productDictionary) {
//                    self._items.append(dict)
//                }
//            }
//        }

        let dict : NSDictionary = ["Brand" : "Brand",
                                   "ImageURLs" : ["https://everlane-2.imgix.net/i/a2d61e0b_8480.jpg?w=1200&h=1200&q=65&dpr=1", "https://everlane-2.imgix.net/i/a491f49e_f1df.jpg?w=1200&h=1200&q=65&dpr=1"],
                                   "ItemName" : "Name",
                                   "Price" : 30.0,
                                   "ID" : "ID",
                                   "Description" : "This is a description",
                                   "PrimaryImage" : "https://media.giphy.com/media/3o7btZPuz5HJ0UY3zq/giphy.gif",
                                   "Show" : "true"]
        let item2 : NSDictionary = ["Brand" : "Brand",
                                   "ImageURLs" : ["https://everlane-2.imgix.net/i/a2d61e0b_8480.jpg?w=1200&h=1200&q=65&dpr=1", "https://everlane-2.imgix.net/i/a491f49e_f1df.jpg?w=1200&h=1200&q=65&dpr=1"],
                                   "ItemName" : "Name",
                                   "Price" : 30.0,
                                   "ID" : "ID",
                                   "Description" : "This is a description",
                                   "PrimaryImage" : "https://everlane-2.imgix.net/i/a2d61e0b_8480.jpg?w=1200&h=1200&q=65&dpr=1",
                                   "Show" : "true"]
        self._items.append(Item(dictionary: dict)!)
        self._items.append(Item(dictionary: item2)!)
        completion?(nil)
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
        var imageURL: String
        var show: Bool

        init?(dictionary: NSDictionary) {
            
            guard let brand = dictionary["Brand"] as? String else {
                print("The brand was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let imageURLs = dictionary["ImageURLs"] as? [String] else {
                print("The imageURLs was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let name = dictionary["ItemName"] as? String else {
                print("The name was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let id = dictionary["ID"] as? String else {
                print("The id was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let description = dictionary["Description"] as? String else {
                print("The description was incorrect.")
                print(dictionary)
                return nil
            }
            
            guard let priceNumber = dictionary["Price"] as? Double else {
                print("The price was incorrect.")
                print(dictionary)
                return nil
            }
            
            let price = String(priceNumber)
            
            guard let imageURL = dictionary["PrimaryImage"] as? String else {
                print("The imageURL was incorrect.")
                print(dictionary)
                return nil
            }
            
            if let show = dictionary["Show"] as? String, (show.lowercased() == "false") || (show.lowercased() == "no") {
                self.show = false
            } else {
                self.show = true
            }
            
            self.brand = brand
            self.imageURLs = imageURLs
            self.name = name
            self.price = price
            self.id = id
            self.description = description
            self.imageURL = imageURL
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
