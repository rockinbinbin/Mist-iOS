//
//  Feed.swift
//  Mist
//
//  Created by Steven on 6/17/16.
//
//

import Foundation
//import AWSMobileHubHelper


class Feed {

    static let sharedInstance = Feed()    
    fileprivate lazy var _posts: [Post] = []
    
    var posts: [Post] {
        get {
            var posts: [Post] = []
            originalIndices = []
            
            for (index, post) in _posts.enumerated() {
//                if item.validWithFilters && item.show {
                    originalIndices.append(index)
                    posts.append(post)
//                }
            }
            
            return posts
        }
    }
    
    var searchItems: [Post] {
        get {
            return _posts
        }
    }
    
    fileprivate var originalIndices: [Int] = []

    func sizeAtIndex(_ index: Int) -> CGSize {
        return _posts[originalIndices[index]].size ?? CGSize(width: 500, height: 10)
    }
    
    func setSize(_ size: CGSize, atIndex index: Int) {
        _posts[index].size = size
    }

    func loadFeed(_ completion: ((NSError?) -> ())?) {
        do {
            let url = NSURL(string: Constants.baseURL + "get_posts")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    let tempDict = NSDictionary(dictionary: ["id" : 0, "url" : "url", "timestamp" : "timestamp", "artist_id" : 0, "name" : "name", "price" : 0, "description" : "description"])
                    let tempPost = Post(dictionary: tempDict)
//                    let result_posts : NSArray = [tempPost]
                    self._posts.append(tempPost!)
//                    completion?(error as NSError?)
                    completion?(nil)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    //print("Result -> \(String(describing: result))")
                    let result_posts : NSArray = result?["posts"] as! NSArray
                    for postDict in result_posts {
                        if let dict = Post(dictionary: postDict as! NSDictionary) {
                            self._posts.append(dict)
                        }
                    }
                    completion?(nil)
                } catch {
                    print("Error -> \(error)")
                    completion?(error as NSError)
                }
            }
            task.resume()
        }
    }

    func getArtistFromID(artist_id: String, completion: ((NSError?, Artist?) -> ())?) {
        let json = ["artist_id":artist_id]
        let params = json.stringFromHttpParameters()
        do {
            let url = NSURL(string: Constants.baseURL + "get_artist?" + params)!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "GET"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completion?(error as NSError?, nil)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    print("Result -> \(String(describing: result))")
                    let artist = Artist(dictionary: result! as NSDictionary)
                    completion?(nil, artist)
                } catch {
                    print("Error -> \(error)")
                    completion?(error as NSError, nil)
                }
            }
            task.resume()
        }
    }


    struct Post {
        let id: Int
        let url: String
        let timestamp: String
        let artist_id: Int
        let name: String
        let price: Int
        let description: String
        var size: CGSize? = nil

        init?(dictionary: NSDictionary) {
            guard let id = dictionary["id"] as? Int else {
                print("The id was incorrect.")
                print(dictionary)
                return nil
            }
            guard let url = dictionary["url"] as? String else {
                print("The url was incorrect.")
                print(dictionary)
                return nil
            }
            guard let timestamp = dictionary["timestamp"] as? String else {
                print("The timestamp was incorrect.")
                print(dictionary)
                return nil
            }
            guard let artist_id = dictionary["artist_id"] as? Int else {
                print("The artist_id was incorrect.")
                print(dictionary)
                return nil
            }
            guard let name = dictionary["name"] as? String else {
                print("The name was incorrect.")
                print(dictionary)
                return nil
            }
            guard let price = dictionary["price"] as? Int else {
                print("The price was incorrect.")
                print(dictionary)
                return nil
            }
            guard let description = dictionary["description"] as? String else {
                print("The description was incorrect.")
                print(dictionary)
                return nil
            }
            self.id = id
            self.url = url
            self.timestamp = timestamp
            self.artist_id = artist_id
            self.name = name
            self.price = price
            self.description = description
        }
    }

    struct Artist {
        let id: String
        let username: String
        let email: String
        let post: Post

        init?(dictionary: NSDictionary) {
            guard let id = dictionary["id"] as? String else {
                print("The id was incorrect.")
                print(dictionary)
                return nil
            }
            guard let username = dictionary["username"] as? String else {
                print("The username was incorrect.")
                print(dictionary)
                return nil
            }
            guard let email = dictionary["email"] as? String else {
                print("The id was incorrect.")
                print(dictionary)
                return nil
            }
            guard let post = dictionary["post"] as? NSDictionary else {
                print("The post was incorrect.")
                print(dictionary)
                return nil
            }
            self.id = id
            self.username = username
            self.email = email
            self.post = Post(dictionary: post)!
        }
    }

//    struct Item {
//        let brand: String
//        let imageURLs: [String]
//        let name: String
//        let price: String
//        let id: String
//        let description: String
//        let categories: [Feed.Filter.Category] = []
//        var size: CGSize? = nil
//        var imageURL: String
//        var show: Bool
//
//        init?(dictionary: NSDictionary) {
//            
//            guard let brand = dictionary["Brand"] as? String else {
//                print("The brand was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            guard let imageURLs = dictionary["ImageURLs"] as? [String] else {
//                print("The imageURLs was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            guard let name = dictionary["ItemName"] as? String else {
//                print("The name was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            guard let id = dictionary["ID"] as? String else {
//                print("The id was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            guard let description = dictionary["Description"] as? String else {
//                print("The description was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            guard let priceNumber = dictionary["Price"] as? Double else {
//                print("The price was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            let price = String(priceNumber)
//            
//            guard let imageURL = dictionary["PrimaryImage"] as? String else {
//                print("The imageURL was incorrect.")
//                print(dictionary)
//                return nil
//            }
//            
//            if let show = dictionary["Show"] as? String, (show.lowercased() == "false") || (show.lowercased() == "no") {
//                self.show = false
//            } else {
//                self.show = true
//            }
//            
//            self.brand = brand
//            self.imageURLs = imageURLs
//            self.name = name
//            self.price = price
//            self.id = id
//            self.description = description
//            self.imageURL = imageURL
//        }
//        
//        /**
//         Returns true if at least one of the filters are satisfied from each type of filter.
//         */
//        var validWithFilters: Bool {
//            
//            var satisfied = (categories: false, price: false)
//            
//            let categoryFilters = Feed.Filters.sharedInstance.categories
//            let priceFilters = Feed.Filters.sharedInstance.price
//            
//            if Array(categoryFilters.values).contains(true) {
//                for category in categories {
//                    if categoryFilters[category]! {
//                        satisfied.categories = true
//                    }
//                }
//            } else {
//                satisfied.categories = true
//            }
//            
//            // If no price filters are set, price filter is satisfied.
//            if Array(priceFilters.values).contains(true) {
//                let priceFilter = Feed.Filter.Price(price: Double(price)!)!
//                satisfied.price = priceFilters[priceFilter]!
//            } else {
//                satisfied.price = true
//            }
//            
//            return satisfied.price && satisfied.categories
//        }
//    }
}
