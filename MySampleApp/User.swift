//
//  User.swift
//  Mist
//
//  Created by Robin Mehta on 6/28/17.
//
//

import Foundation

class UserModel {
    static let sharedInstance = UserModel()

    var current_user : User?

    func loginUser(username: String, password: String, completion: ((NSError?, User?) -> ())?) -> Void {
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString() // replace with session token

        do {
            let url = NSURL(string: Constants.baseURL + "login_user")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.setValue("Bearer \(base64LoginString)", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completion!(error as NSError?, nil)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let user = User(dictionary: result! as NSDictionary)
                    print("Result -> \(String(describing: result))")
                    completion!(nil, user as User?)
                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }

    // send password + username as data payload
    func createUser(username: String, password: String, completion: ((NSError?, User?) -> ())?) -> Void {
        // json
        do {
            let url = NSURL(string: Constants.baseURL + "create_user")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"

            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completion!(error as NSError?, nil)
                    return
                }
                do {
                    let result = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:AnyObject]
                    let user = User(dictionary: result! as NSDictionary)
                    print("Result -> \(String(describing: result))")
                    completion!(nil, user as User?)
                } catch {
                    print("Error -> \(error)")
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
}

struct User {
    let id: String
    let username: String
    let email: String
    let sessionToken: String = ""

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
            print("The email was incorrect.")
            print(dictionary)
            return nil
        }
        self.id = id
        self.username = username
        self.email = email
    }
}
