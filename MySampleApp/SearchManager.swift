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
    
    func uniqueElements<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    /**
     Returns true iff all of the words in the query are in some field of the product.
     */
    private func productPredicate(text: String, product: Feed.Item) -> Bool {
        var words = uniqueElements(text.componentsSeparatedByString(" ").filter{$0 != ""}.map{$0.lowercaseString})
        
        let searchableFields = [product.name, product.description, product.brand, product.price]
        
        for field in searchableFields {
            for word in words {
                if field.containsString(word) {
                    words.removeAtIndex(words.indexOf(word)!)
                    
                    if words.count == 0 {
                        return true
                    }
                }
            }
        }
        
        for category in product.categories {
            for word in words {
                if category.description.containsString(word) {
                    words.removeAtIndex(words.indexOf(word)!)
                    
                    if words.count == 0 {
                        return true
                    }
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
