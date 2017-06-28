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
        var imageURL: String
        var name: String
        var description: String
    }
    
    struct Product {
        
    }
}

class SearchManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = SearchManager()
    
    // MARK: - Search
    
    func search(_ text: String, completion: ((_ products: [Feed.Post], _ brands: [SearchResult.Brand]) -> ())? = nil) {
        var products: [Feed.Post] = []
        
        // TODO: Implement brand search
        let brands: [SearchResult.Brand] = []
        
        for product in Feed.sharedInstance.searchItems {
            if productPredicate(text, product: product) {
                products.append(product)
            }
        }
        
        completion?(products, brands)
    }
    
    func uniqueElements<S : Sequence, T : Hashable>(_ source: S) -> [T] where S.Iterator.Element == T {
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
    
    let debugBrands: [SearchResult.Brand] = [
        SearchResult.Brand(imageURL: "http://www.thealibiinteriors.com/uploads/2/0/9/4/20944724/s408668824554312519_p15_i2_w640.jpeg", name: "Reformation", description: "We make killer clothes that don't kill the environment. Shop eco-friendly dresses, tops, bottoms, jumpers, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear & our new wedding collection."),
        SearchResult.Brand(imageURL: "https://cdn.shopify.com/s/files/1/0547/5393/files/elephant_header.jpg?3042279246950339242", name: "The Elephant Pants", description: "In 2014, The Elephant Pants embarked on a mission to help save elephans and feel damn good while doing it."),
        SearchResult.Brand(imageURL: "http://www.thealibiinteriors.com/uploads/2/0/9/4/20944724/s408668824554312519_p15_i2_w640.jpeg", name: "Reformation", description: "We make killer clothes that don't kill the environment. Shop eco-friendly dresses, tops, bottoms, jumpers, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear & our new wedding collection."),
        SearchResult.Brand(imageURL: "https://cdn.shopify.com/s/files/1/0547/5393/files/elephant_header.jpg?3042279246950339242", name: "The Elephant Pants", description: "In 2014, The Elephant Pants embarked on a mission to help save elephans and feel damn good while doing it."),
        SearchResult.Brand(imageURL: "https://cdn.shopify.com/s/files/1/0547/5393/files/elephant_header.jpg?3042279246950339242", name: "The Elephant Pants", description: "In 2014, The Elephant Pants embarked on a mission to help save elephans and feel damn good while doing it."),
        SearchResult.Brand(imageURL: "http://www.thealibiinteriors.com/uploads/2/0/9/4/20944724/s408668824554312519_p15_i2_w640.jpeg", name: "Reformation", description: "We make killer clothes that don't kill the environment. Shop eco-friendly dresses, tops, bottoms, jumpers, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear, outerwear, tops, bottoms, jumpers, outerwear & our new wedding collection."),
        SearchResult.Brand(imageURL: "https://cdn.shopify.com/s/files/1/0547/5393/files/elephant_header.jpg?3042279246950339242", name: "The Elephant Pants", description: "In 2014, The Elephant Pants embarked on a mission to help save elephans and feel damn good while doing it."),
    ]
    
    /**
     Returns true iff all of the words in the query are in some field of the product.
     */
    fileprivate func productPredicate(_ text: String, product: Feed.Post) -> Bool {
        var words = uniqueElements(text.components(separatedBy: " ").filter{$0 != ""}.map{$0.lowercased()})
        
//        let searchableFields = [product.name, product.description, product.brand, product.price]
//        
//        for field in searchableFields {
//            for word in words {
//                if field.contains(word) {
//                    words.remove(at: words.index(of: word)!)
//                    
//                    if words.count == 0 {
//                        return true
//                    }
//                }
//            }
//        }

//        for category in product.categories {
//            for word in words {
//                if category.description.contains(word) {
//                    words.remove(at: words.index(of: word)!)
//                    
//                    if words.count == 0 {
//                        return true
//                    }
//                }
//            }
//        }

        return false
    }
    
    // TODO: Implement
    fileprivate func brandPredicate(_ text: String) -> Bool {
        return false
    }
    
    // MARK: - Search History
    
    var previousSearches = [String](repeating: "", count: 5)
    
    // MARK: - Utility
    
    func addRecentSearch(_ query: String) {
        previousSearches.shiftRightInPlace(-1)
        previousSearches[0] = query
    }
}

// MARK: - Array shifting

extension Array {
    func shiftRight(_ amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(_ amount: Int = 1) {
        self = shiftRight(amount)
    }
}
