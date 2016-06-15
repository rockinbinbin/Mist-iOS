//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/13/16.
//
//

import UIKit
import AWSMobileHubHelper

class FeedViewController: UIViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        
        view.backgroundColor = .whiteColor()
        
        setViewConstraints()
        
        AWSMobileClient.sharedInstance.loadImagesFromAWS { (contents: [AWSContent]?, error: NSError?) -> Void in
            guard error == nil else {
                print(error)
                return
            }
            
            guard contents != nil else {
                return
            }
            
            self.contents = contents!
        }
    }
    
    // MARK: - UI Components
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Model
    
    private var contents: [AWSContent] = [] {
        didSet {
            refreshImages()
        }
    }
    
    // MARK: - Layout
    
    func setViewConstraints() {
        imageView.centerInSuperview()
        imageView.sizeToHeight(500)
        imageView.sizeToWidth(300)
    }
    
    // MARK: - Collection View
    
    func refreshImages() {
        guard contents.count > 0 else {
            print("empty contents")
            return
        }
        
        
        for content in contents {
            content.getRemoteFileURLWithCompletionHandler({ (url: NSURL?, error: NSError?) -> Void in
                guard let url = url else {
                    print("Error getting URL for file. \(error)")
                    return
                }
                
                let image = UIImage(data: NSData(contentsOfURL: url)!)
                self.imageView.image = image
            })
        }
    }
}
