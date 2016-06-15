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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        return collectionView
    }()
    
    // MARK: - Model
    
    private var contents: [AWSContent] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Layout
    
    func setViewConstraints() {
        // Set constraints for the view.
    }
}
