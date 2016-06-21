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
    
    override func viewDidAppear(animated: Bool) {
        statusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
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
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.AccountPressed)
        presentViewController(UINavigationController(rootViewController: AccountViewController()), animated: true, completion: nil)
    }
    
    func presentSearchViewController() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.SearchPressed)
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
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeedCell
        
        let product = Feed.sharedInstance.items[indexPath.row]
        productViewController.product = product
        productViewController.mainImage = cell.image

        // Record in mobile analytics
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.ItemCellPressed)
        
        transitionToCell(indexPath) {completion in
            self.presentViewController(productViewController, animated: false, completion: completion)
        }
    }
    
    // MARK: - Status Bar
    
    var statusBarHidden: Bool = false
    
    override func prefersStatusBarHidden() -> Bool {
        return statusBarHidden
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade
    }
}

// MARK: - Transition

extension FeedViewController {
    
    private func transitionToCell(indexPath: NSIndexPath, presentViewHandler: (didFinishPresentingView: () -> ()) -> ()) {
        let window = UIApplication.sharedApplication().keyWindow
        
        let newImageView = _transition_newImageView(indexPath)
        let blackView = _transition_blackView()
        window?.addSubview(blackView)
        window?.addSubview(newImageView)
        
        let blackGradient = _transition_blackGradient()
        blackGradient.clipsToBounds = true
        blackGradient.frame = CGRectMake(0, newImageView.frame.size.height - 75, newImageView.frame.size.width, 75)
        newImageView.addSubview(blackGradient)

        let imageHeight = (newImageView.image!.size.height / newImageView.image!.size.width) * self.view.frame.width
        let finalFrame = CGRectMake(0, 0, self.view.frame.size.width, imageHeight)
        let finalGradientFrame = CGRectMake(0, finalFrame.size.height - 75, finalFrame.size.width, 75)
        
        statusBarHidden = true
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
            newImageView.frame = finalFrame
            blackGradient.frame = finalGradientFrame
            blackView.layer.opacity = 1.0
            self.setNeedsStatusBarAppearanceUpdate()
            }) { (Bool) in
                presentViewHandler() {
                    newImageView.removeFromSuperview()
                    blackView.removeFromSuperview()
                }
        }
    }
    
    // MARK: - UI Components
    
    private func _transition_newImageView(indexPath: NSIndexPath) -> UIImageView {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeedCell
        let image = cell.image
        
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let cellRect = attributes!.frame
        let cellFrameInWindow = collectionView.convertRect(cellRect, toView: nil)
        
        let newImageView = UIImageView(image: image)
        newImageView.frame = cellFrameInWindow

        return newImageView
    }
    
    private func _transition_blackGradient() -> UIView {
        let _blackGradientOverlay: UIView = UIView(frame: CGRectMake(0, 0, 1000, 75))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, atIndex: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        return _blackGradientOverlay
    }
    
    private func _transition_blackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .blackColor()
        view.layer.opacity = 0
        view.frame = UIScreen.mainScreen().bounds
        return view
    }
}
