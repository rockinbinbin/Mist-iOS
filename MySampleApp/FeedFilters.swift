//
//  FeedFilters.swift
//  Mist
//
//  Created by Steven on 7/8/16.
//
//

import Foundation

extension Feed {
    struct Filter {
        enum Category: CustomStringConvertible {
            case Mens
            case Womens
            case Kids
            case Lifestyle
            case Beauty
            
            var description: String {
                switch self {
                case Mens: return "Men's"
                case Womens: return "Women's"
                case Kids: return "Kids"
                case Lifestyle: return "Lifestyle"
                case Beauty: return "Beauty"
                }
            }
            
            static let allValues = [Mens, Womens, Kids, Lifestyle, Beauty]
        }
        
        enum Price: CustomStringConvertible {
            case Under30
            case Under75
            case Under150
            case Under400
            case Over400
            
            var description: String {
                switch self {
                case Under30: return "Under $30"
                case Under75: return "$30 - $75"
                case Under150: return "$75 - $150"
                case Under400: return "$150 - $400"
                case Over400: return "$400+"
                }
            }
            
            init?(price: Double) {
                guard price >= 0 else {
                    return nil
                }
                
                switch price {
                case 0..<30:    self = Under30
                case 30..<75:   self = Under75
                case 75..<150:  self = Under150
                case 150..<400: self = Under400
                default:        self = Over400
                }
            }
            
            static let allValues = [Under30, Under75, Under150, Under400, Over400]
        }
    }
    
    struct Filters {
        
        static var sharedInstance = Filters()
        
        lazy var categories: [Filter.Category : Bool] = {
            var filters: [Filter.Category : Bool] = [:]
            
            for category in Filter.Category.allValues {
                filters[category] = false
            }
            
            return filters
        }()
        
        lazy var price: [Filter.Price : Bool] = {
            var filters: [Filter.Price : Bool] = [:]
            
            for price in Filter.Price.allValues {
                filters[price] = false
            }
            
            return filters
        }()
    }
}