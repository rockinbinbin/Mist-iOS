//
//  UtilityFunctions.swift
//  MySampleApp
//
//  Use this file to add Utility Functions shared by the App
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.2
//

import UIKit

func prettyPrintJson(object: AnyObject?) -> String {
    var prettyResult: String = ""
    if object == nil {
        return ""
    } else if let resultArray = object as? [AnyObject] {
        var entries: String = ""
        for index in 0..<resultArray.count {
            if (index == 0) {
                entries = "\(resultArray[index])"
            } else {
                entries = "\(entries), \(prettyPrintJson(resultArray[index]))"
            }
        }
        prettyResult = "[\(entries)]"
    } else if object is NSDictionary  {
        let objectAsDictionary: [String: AnyObject] = object as! [String: AnyObject]
        prettyResult = "{"
        var entries: String = ""
        for (key,_) in objectAsDictionary {
            entries = "\"\(entries), \"\(key)\":\(prettyPrintJson(objectAsDictionary[key]))"
        }
        prettyResult = "{\(entries)}"
        return prettyResult
    } else if let objectAsNumber = object as? NSNumber {
        prettyResult = "\(objectAsNumber.stringValue)"
    } else if let objectAsString = object as? NSString {
        prettyResult = "\"\(objectAsString)\""
    }
    return prettyResult
}

/**
 Downloads an image asynchronously.
 
 - parameter remoteURL: The URL of the remote image.
 - parameter completion: A block of
 */
func downloadImageAsync(remoteURL: String, completion: (success: Bool, image: UIImage?) -> ()) {
    guard let url = NSURL(string: remoteURL) else {
        completion(success: false, image: nil)
        return
    }
    
    let request = NSMutableURLRequest(URL: url)
    
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
        (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
        
    }
}

extension UIImage {
//    convenience init(downloadURL: String) {
//        
//    }
}