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
    
    func search(text: String) -> (brands: [SearchResult.Brand], products: [Feed.Item]) {
        var result: (brands: [SearchResult.Brand], products: [Feed.Item]) = ([], [])
        
        for product in Feed.sharedInstance.searchItems {
            if productPredicate(text, product: product) {
                result.products.append(product)
            }
        }
        
        return result
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