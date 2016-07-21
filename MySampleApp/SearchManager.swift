//
//  SearchManager.swift
//  Mist
//
//  Created by Steven on 7/17/16.
//
//

import Foundation

struct SearchResult {
    struct Brand {
        
    }
    
    struct Product {
        
    }
}

class SearchManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = SearchManager()
    
    // MARK: - Search
    
    func search(text: String, completion: ((products: [Feed.Item], brands: [SearchResult.Brand]) -> ())? = nil) {
        var products: [Feed.Item] = []
        
        // TODO: Implement brand search
        let brands: [SearchResult.Brand] = []
        
        for product in Feed.sharedInstance.searchItems {
            if productPredicate(text, product: product) {
                products.append(product)
            }
        }
        
        completion?(products: products, brands: brands)
    }
    
    private func productPredicate(text: String, product: Feed.Item) -> Bool {
        let words = text.componentsSeparatedByString(" ").map{$0.lowercaseString}
        
        let searchableFields = [product.name, product.description, product.brand, product.price]
        
        for field in searchableFields {
            for word in words {
                if field.containsString(word) {
                    return true
                }
            }
        }
        
        for category in product.categories {
            for word in words {
                if category.description.containsString(word) {
                    return true
                }
            }
        }
        
        return false
    }
    
    // TODO: Implement
    private func brandPredicate(text: String) -> Bool {
        return false
    }
    
    // MARK: - Search History
    
    var previousSearches = [String](count: 5, repeatedValue: "")
    
    // MARK: - Utility
    
    func addRecentSearch(query: String) {
        previousSearches.shiftRightInPlace(-1)
        previousSearches[0] = query
    }
}

// MARK: - Array shifting

extension Array {
    func shiftRight(amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount)
    }
}
