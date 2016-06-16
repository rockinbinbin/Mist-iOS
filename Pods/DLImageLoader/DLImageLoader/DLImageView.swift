//
//  DLImageView.swift
//
//  Created by Andrey Lunevich
//  Copyright © 2015 Andrey Lunevich. All rights reserved.

//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at

//  http://www.apache.org/licenses/LICENSE-2.0

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import UIKit

public class DLImageView: UIImageView {

    private(set) var url: String? = ""
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }

    /**
        Display image from url
        - parameter url: The url of image.
     */
    public func imageFromUrl(url: String)
    {
        let request = NSURLRequest(URL: NSURL(string: url)!)
        imageFromRequest(request)
    }
    
    /**
        Load image from url
        - parameter url: The url of image.
        - parameter completed: Completion block that will be called after image loading.
     */
    public func imageFromUrl(url: String, completed:((error :NSError!, image: UIImage!) ->())? = nil)
    {
        imageFromRequest(NSURLRequest(URL: NSURL(string: url)!), completed: completed)
    }
    
    /**
        Display image from request
        - parameter request: The request of image.
     */
    public func imageFromRequest(request: NSURLRequest)
    {
        imageFromRequest(request) { (error, image) -> () in
            self.image = image
        }
    }
    
    /**
        Load image from request
        - parameter request: The request of image.
        - parameter completed: Completion block that will be called after image loading.
     */
    public func imageFromRequest(request: NSURLRequest,
                                 completed:((error :NSError!, image: UIImage!) ->())? = nil)
    {
        self.url = request.URL?.absoluteString
        self.image = nil
        DLImageLoader.sharedInstance.imageFromRequest(request, completed: completed)
    }
    
    /**
        Cancel started operation
     */
    public func cancelLoading()
    {
        DLImageLoader.sharedInstance.cancelOperation(self.url)
    }
    
    
    // MARK: - private methods
    
    private func configureView()
    {
        self.contentMode = UIViewContentMode.ScaleAspectFit
    }
}
