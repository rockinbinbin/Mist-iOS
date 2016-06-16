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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mistLogoInTitle = true
        
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
            
            LoadingView.sharedInstance.hideView()
            
            self.contents = contents!
        }
    }
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 3.0
        layout.minimumInteritemSpacing = 50
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
    
    // MARK: - Product Card
    
    struct FeedCellInfo {
        var cell: FeedCell?
        var image: UIImage? { get { return cell?.image } }
        var size: CGSize? { get { return image?.size } }
    }
    
    private var feedCellMetadata: [FeedCellInfo] = [FeedCellInfo(), FeedCellInfo(), FeedCellInfo(), FeedCellInfo(), FeedCellInfo(), FeedCellInfo()]
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
//        return contents.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        feedCellMetadata[indexPath.row].cell = cell
        
        let url = "https://s3.amazonaws.com/mist-contentdelivery-mobilehub-605039644/product-media/Image.jpg"
        
        guard cell.image == nil else {
            return cell
        }
        
        cell.setImage(url) { (completed) in
            if completed {
                dispatch_async(dispatch_get_main_queue()) {
                    self.collectionView.reloadData()
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
    
    // MARK: - Model
    
    private var contents: [AWSContent] = [] {
        didSet {
//            collectionView.reloadData()
        }
    }
    
    // MARK: - Layout
    
    func setViewConstraints() {
        collectionView.pinToEdgesOfSuperview()
    }
}
