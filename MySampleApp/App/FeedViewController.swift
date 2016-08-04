//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/13/16.
//
//

import UIKit
import AWSMobileHubHelper

class FeedViewController: MMViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, FeedProductTransitionDelegate, FilterDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        loadFeed()
        setViewConstraints()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = false
        statusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    private func configureAppearance() {
        mistLogoInTitle = true
        setLeftButton("Filters", target: self, selector: #selector(presentFilters))
        setRightButton("Search", target: self, selector: #selector(presentSearchViewController))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .blackColor()

        self.collectionView.backgroundColor = UIColor(patternImage: UIImage(named: "RepeatingGradient")!)
    }
    
    private func loadFeed() {
        Feed.sharedInstance.loadFeed { (error: NSError?) in
            guard error == nil else {
                print("Error loading feed: \(error)")
                return
            }
            
            for _ in Feed.sharedInstance.items {
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
    
    // MARK: - Layout
    
    func setViewConstraints() {
        collectionView.pinToEdgesOfSuperview()
    }
    
    // MARK: - Model
    
    /**
     An array of bools, corresponding with each indexPath.row, if the image is currently loading or not.
     */
    private var imageLoading: [Bool] = []
    
    // MARK: - Navigation
    
    func presentFilters() {
        let filterView = FilterView()
        filterView.delegate = self
        
        guard let window = UIApplication.sharedApplication().keyWindow else {
            return
        }
        
        filterView.frame = window.frame
        window.addSubview(filterView)
    }
    
    // MARK: - Filter Delegate
    
    private lazy var whiteOverlay: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .whiteColor()
        view.layer.opacity = 0
        self.view.addSubview(view)
        return view
    }()
    
    func didUpdateFilters() {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.view.userInteractionEnabled = false
            
            let timeInterval: NSTimeInterval = 0.25
            
            UIView.animateWithDuration(timeInterval, animations: {
                self.whiteOverlay.layer.opacity = 1
                }, completion: { (Bool) in
                    self.collectionView.reloadData()
            })
            
            UIView.animateWithDuration(timeInterval, delay: timeInterval, options: .CurveEaseInOut, animations: {
                self.whiteOverlay.layer.opacity = 0
                }, completion: { (Bool) in
                    self.view.userInteractionEnabled = true
            })
        }
    }
    
    func presentAccountViewController() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.AccountPressed)
        presentViewController(UINavigationController(rootViewController: AccountViewController()), animated: true, completion: nil)
    }
    
    func presentSearchViewController() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.SearchPressed)
        self.navigationController!.pushViewController(SearchViewController(), animated: true)
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Feed.sharedInstance.items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! FeedCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        guard indexPath.row < Feed.sharedInstance.items.count else {
            return cell
        }
        
        let product = Feed.sharedInstance.items[indexPath.row]
        
        if let productID = cell.productID where productID == product.id {
            return cell
        }
        
        if let productDescription = cell.productDescription where productDescription == product.description {
            return cell
        }
        
        cell.product = product
        
        imageLoading[indexPath.row] = true
        
        cell.setImage(product.imageURL) { (completed, image) in
            if completed {
                dispatch_async(dispatch_get_main_queue()) {
                    self.imageLoading[indexPath.row] = false
                    Feed.sharedInstance.setSize((image?.size)!, atIndex: indexPath.row)

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
        return Feed.sharedInstance.sizeAtIndex(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productViewController = ProductViewController()
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeedCell
        
        let product = Feed.sharedInstance.items[indexPath.row]
        productViewController.product = product
        productViewController.imageURLs = product.imageURLs
        productViewController.mainImage = cell.image
        productViewController.delegate = self

        // Record in mobile analytics
        AnalyticsManager.sharedInstance.recordEvent(Event.Feed.ItemCellPressed)
        
        transitionToProduct(fromIndex: indexPath) {completion in
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
    
    // MARK: - Product View
    
    var activeIndexPath: NSIndexPath? = nil
    var activeCellFrame: CGRect? = nil
}

// MARK: - Transition

protocol FeedProductTransitionDelegate {
    func transitionToCell(fromImageFrame imageFrame: CGRect, dismissViewControllerHandler: () -> ())
}

extension FeedViewController {
    
    func transitionToProduct(fromIndex indexPath: NSIndexPath, presentViewHandler: (didFinishPresentingView: () -> ()) -> ()) {
        let window = UIApplication.sharedApplication().keyWindow
        
        let newImageView = _transition_newImageView(indexPath)
        let blackView = _transition_blackView()
        window?.addSubview(blackView)
        window?.addSubview(newImageView)
        
        newImageView.frame = _transition_getCellGlobalFrame(indexPath)
        
        let blackGradient = _transition_blackGradient()
        blackGradient.clipsToBounds = true
        blackGradient.frame = CGRectMake(0, newImageView.frame.size.height - 75, newImageView.frame.size.width, 75)
        newImageView.addSubview(blackGradient)

        let imageHeight = (newImageView.image!.size.height / newImageView.image!.size.width) * self.view.frame.width
        let finalFrame = CGRectMake(0, 0, self.view.frame.size.width, imageHeight)
        let finalGradientFrame = CGRectMake(0, finalFrame.size.height - 75, finalFrame.size.width, 75)
        
        statusBarHidden = true
        activeIndexPath = indexPath
        activeCellFrame = newImageView.frame
        
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
    
    func transitionToCell(fromImageFrame imageFrame: CGRect, dismissViewControllerHandler: () -> ()) {
        guard let indexPath = activeIndexPath else {
            return
        }
        
        defer {
            activeIndexPath = nil
            activeCellFrame = nil
        }
        
        let window = UIApplication.sharedApplication().keyWindow
        let newImageView = _transition_newImageView(indexPath)
        newImageView.frame = CGRectMake(imageFrame.minX, 0, imageFrame.width, imageFrame.height)
        let blackView = _transition_blackView()
        blackView.layer.opacity = 1.0
        
        window?.addSubview(blackView)
        window?.addSubview(newImageView)
        
        let blackGradient = _transition_blackGradient()
        blackGradient.clipsToBounds = true
        blackGradient.frame = CGRectMake(0, newImageView.frame.size.height - 75, newImageView.frame.size.width, 75)
        newImageView.addSubview(blackGradient)
        
        statusBarHidden = false
        
        let finalFrame = activeCellFrame!
        let finalGradientFrame = CGRectMake(0, finalFrame.size.height - 75, finalFrame.size.width, 75)
        
        dismissViewControllerHandler()
        
        UIView.animateWithDuration(0.25, delay: 0, options: .CurveEaseInOut, animations: {
            newImageView.frame = finalFrame
            blackView.layer.opacity = 0.0
            blackGradient.frame = finalGradientFrame
            self.setNeedsStatusBarAppearanceUpdate()
        }) { (Bool) in
            newImageView.removeFromSuperview()
            blackView.removeFromSuperview()
        }
    }
    
    // MARK: - UI Components
    
    private func _transition_getCellGlobalFrame(indexPath: NSIndexPath) -> CGRect {
        let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath)
        let cellRect = attributes!.frame
        
        return collectionView.convertRect(cellRect, toView: nil)
    }
    
    private func _transition_newImageView(indexPath: NSIndexPath) -> UIImageView {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FeedCell
        let image = cell.image
        
        let newImageView = UIImageView(image: image)

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
