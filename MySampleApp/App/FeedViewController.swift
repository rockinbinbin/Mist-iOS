//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/13/16.
//
//

import UIKit
import AWSMobileHubHelper

class FeedViewController: MMViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        loadFeed()
        setViewConstraints()
    }
    
    private func configureAppearance() {
        mistLogoInTitle = true
        setLeftButton("Account", target: self, selector: #selector(presentAccountViewController))
        setRightButton("Search", target: self, selector: #selector(presentSearchViewController))
        view.backgroundColor = .whiteColor()
    }
    
    private func loadFeed() {
        Feed.sharedInstance.loadFeed { (error: NSError?) in
            guard error == nil else {
                print("Error loading feed: \(error)")
                return
            }
            
            for _ in Feed.sharedInstance.items {
                self.imageLoading.append(false)
                self.imageSizes.append(CGSizeZero)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.headerHeight = 3.0
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .whiteColor()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerClass(FeedCell.self, forCellWithReuseIdentifier: "cell")
        
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
        collectionView.pinToEdgesOfSuperview()
    }
    
    // MARK: - Model
    
    /**
     An array of bools, corresponding with each indexPath.row, if the image is currently loading or not.
     */
    private var imageLoading: [Bool] = []
    
    /**
     An array of sizes for each image. Corresponds with each indexPath.row.
     */
    private var imageSizes: [CGSize] = []
    
    // MARK: - Navigation
    
    func presentAccountViewController() {
        presentViewController(UINavigationController(rootViewController: AccountViewController()), animated: true, completion: nil)
    }
    
    func presentSearchViewController() {
        print("hi")
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Feed.sharedInstance.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        
        guard indexPath.row < Feed.sharedInstance.items.count else {
            return cell
        }
        
        let product = Feed.sharedInstance.items[indexPath.row]
        
        if let productID = cell.productID where productID == product.id {
            return cell
        }
        
        cell.product = product
        
        imageLoading[indexPath.row] = true
        
        cell.setImage(product.imageURL) { (completed, image) in
            if completed {
                dispatch_async(dispatch_get_main_queue()) {
                    self.imageLoading[indexPath.row] = false
                    self.imageSizes[indexPath.row] = (image?.size)!

                    if (self.imageLoading.indexOf(true) == nil && !LoadingView.sharedInstance.hasHiddenOnce) {
                        LoadingView.sharedInstance.hasHiddenOnce = true
                        self.collectionView.reloadData()
                        LoadingView.sharedInstance.hideView()
                    }
                }
            }
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return imageSizes[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productViewController = ProductViewController()
    
        // TODO [Analytics]: Record the "product selected" event
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
}
