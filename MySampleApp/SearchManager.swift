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
        let searchableFields = [product.name, product.description, product.brand, product.price]
        
        for field in searchableFields {
            if field.containsString(text) {
                return true
            }
        }
        
        for category in product.categories {
            if category.description.containsString(text) {
                return true
            }
        }
        
        return false
    }
    
    // TODO: Implement
    private func brandPredicate(text: String) -> Bool {
        return false
    }
}