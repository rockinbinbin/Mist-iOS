//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/13/16.
//
//

import UIKit
import AWSMobileHubHelper

class MMViewController: UIViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.backgroundColor = .whiteColor()
        navigationController?.navigationBar.translucent = false
    }
    
    var mistLogoInTitle: Bool = false {
        didSet {
            if mistLogoInTitle {
                navigationItem.titleView = UIImageView(image: UIImage(named: "Products-Mist-Logo"))
            }
        }
    }
}

class FeedViewController: MMViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    // MARK: - View Lifecycle
    
    struct ProductInfo {
        var brand: String
        var imageURL: String
        var name: String
        
        init?(dictionary: NSDictionary) {
            guard let brand = dictionary["brand"] as? String else {
                return nil
            }
            
            guard let imageURL = dictionary["imageURL"] as? String else {
                return nil
            }
            
            guard let name = dictionary["name"] as? String else {
                return nil
            }
            
            self.brand = brand
            self.imageURL = imageURL
            self.name = name
        }
    }
    
    var feed: [ProductInfo] = []
    
    // MARK: - Product Card
    
    struct FeedCellInfo {
        var cell: FeedCell?
        var image: UIImage? { get { return cell?.image } }
        var size: CGSize? { get { return image?.size } }
    }
    
    private var feedCellMetadata: [FeedCellInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistLogoInTitle = true
        
        view.backgroundColor = .whiteColor()
        
        setViewConstraints()
        
        AWSCloudLogic.defaultCloudLogic().invokeFunction("generateFeed", withParameters: nil) { (result: AnyObject?, error: NSError?) in
            guard error == nil else {
                print(error)
                return
            }
            
            guard let rawFeed = (result as? NSDictionary)?["feed"] as? [NSDictionary] else {
                print("shit")
                return
            }
            
            for productDictionary in rawFeed {
                self.feed.append(ProductInfo(dictionary: productDictionary)!)
                self.feedCellMetadata.append(FeedCellInfo())
                self.imageLoading.append(false)
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
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feed.count
    }
    
    var imageLoading: [Bool] = []
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        feedCellMetadata[indexPath.row].cell = cell
        
        guard cell.image == nil else {
            return cell
        }
        
        imageLoading[indexPath.row] = true
        
        cell.setImage(feed[indexPath.row].imageURL) { (completed) in
            if completed {
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
                    self.imageLoading[indexPath.row] = false

                    if (self.imageLoading.indexOf(true) == nil) {
                        LoadingView.sharedInstance.hideView() {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let defaultSize = CGSize(width: 5, height: 5)
        
        guard feedCellMetadata.count > indexPath.row else {
            return defaultSize
        }
        
        guard let size = feedCellMetadata[indexPath.row].size else {
            return defaultSize
        }
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productViewController = ProductViewController()
    
        // TODO [Analytics]: Record the "product selected" event
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    // MARK: - Layout
    
    func setViewConstraints() {
        collectionView.pinToEdgesOfSuperview()
    }
}
