//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/6/16.
//  Copyright © 2016 Bounce Labs, Inc. All rights reserved.
//

import UIKit

/**
 The view controller for presenting the standard feed of products.
 */
class FeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .greenColor()
    }
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        return UICollectionView()
    }()
}

