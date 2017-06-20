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
            case mens
            case womens
            case kids
            case lifestyle
            case beauty
            
            var description: String {
                switch self {
                case .mens: return "Men's"
                case .womens: return "Women's"
                case .kids: return "Kids"
                case .lifestyle: return "Lifestyle"
                case .beauty: return "Beauty"
                }
            }
            
            static let allValues = [mens, womens, kids, lifestyle, beauty]
        }
        
        enum Price: CustomStringConvertible {
            case under30
            case under75
            case under150
            case under400
            case over400
            
            var description: String {
                switch self {
                case .under30: return "Under $30"
                case .under75: return "$30 - $75"
                case .under150: return "$75 - $150"
                case .under400: return "$150 - $400"
                case .over400: return "$400+"
                }
            }
            
            init?(price: Double) {
                guard price >= 0 else {
                    return nil
                }
                
                switch price {
                case 0..<30:    self = .under30
                case 30..<75:   self = .under75
                case 75..<150:  self = .under150
                case 150..<400: self = .under400
                default:        self = .over400
                }
            }
            
            static let allValues = [under30, under75, under150, under400, over400]
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
