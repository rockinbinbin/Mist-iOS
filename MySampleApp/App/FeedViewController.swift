//
//  FeedViewController.swift
//  Mist
//
//  Created by Steven on 6/13/16.
//
//

import UIKit
import AWSMobileHubHelper
import CHTCollectionViewWaterfallLayout

class FeedViewController: MMViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, FeedProductTransitionDelegate, FilterDelegate {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAppearance()
        loadFeed()
        setViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        statusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    fileprivate func configureAppearance() {
        mistLogoInTitle = true
        //setLeftButton("Filters", target: self, selector: #selector(presentFilters))
        setLeftButton("Account", target: self, selector: #selector(presentAccountViewController))
        setRightButton("Search", target: self, selector: #selector(presentSearchViewController))
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .black
    }
    
    fileprivate func loadFeed() {
        Feed.sharedInstance.loadFeed { (error: NSError?) in
            guard error == nil else {
                print("Error loading feed: \(String(describing: error))")
                return
            }
            
            for _ in Feed.sharedInstance.posts {
                self.imageLoading.append(false)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - UI Components
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.headerHeight = 3.0
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.configureCollectionView()
        self.view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: - Layout
    
    func setViewConstraints() {
        collectionView.autoPinEdgesToSuperviewEdges()
    }
    
    // MARK: - Model
    
    /**
     An array of bools, corresponding with each indexPath.row, if the image is currently loading or not.
     */
    fileprivate var imageLoading: [Bool] = []
    
    // MARK: - Navigation
    
    func presentFilters() {
        let filterView = FilterView()
        filterView.delegate = self
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        filterView.frame = window.frame
        window.addSubview(filterView)
    }
    
    // MARK: - Filter Delegate
    
    fileprivate lazy var whiteOverlay: UIView = {
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .white
        view.layer.opacity = 0
        self.view.addSubview(view)
        return view
    }()
    
    func didUpdateFilters() {
        DispatchQueue.main.async {
            
            self.view.isUserInteractionEnabled = false
            
            let timeInterval: TimeInterval = 0.25
            
            UIView.animate(withDuration: timeInterval, animations: {
                self.whiteOverlay.layer.opacity = 1
                }, completion: { (Bool) in
                    self.collectionView.reloadData()
            })
            
            UIView.animate(withDuration: timeInterval, delay: timeInterval, options: UIViewAnimationOptions(), animations: {
                self.whiteOverlay.layer.opacity = 0
                }, completion: { (Bool) in
                    self.view.isUserInteractionEnabled = true
            })
        }
    }
    
    func presentAccountViewController() {
        present(UINavigationController(rootViewController: AccountViewController()), animated: true, completion: nil)
    }
    
    func presentSearchViewController() {
        self.navigationController!.pushViewController(SearchViewController(), animated: true)
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Feed.sharedInstance.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedCell
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale

        guard indexPath.row < Feed.sharedInstance.posts.count else { return cell }
        let product = Feed.sharedInstance.posts[indexPath.row]
        
        if let productID = cell.productID, productID == product.id {
            return cell
        }
        
        if let productDescription = cell.productDescription, productDescription == product.description { return cell }
        cell.product = product
        imageLoading[indexPath.row] = true
        
        cell.setImage(product.url) { (completed, image) in
            if completed {
                DispatchQueue.main.async {
                    self.imageLoading[indexPath.row] = false
                    Feed.sharedInstance.setSize((image?.size)!, atIndex: indexPath.row)

                    if (self.imageLoading.index(of: true) == nil && !LoadingView.sharedInstance.hasHiddenOnce) {
                        LoadingView.sharedInstance.hasHiddenOnce = true
                        self.collectionView.reloadData()
                        LoadingView.sharedInstance.hideView()
                    }
                }
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return Feed.sharedInstance.sizeAtIndex(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productViewController = ProductViewController()
        
        let cell = collectionView.cellForItem(at: indexPath) as! FeedCell
        
        let product = Feed.sharedInstance.posts[indexPath.row]
        productViewController.product = product
        //productViewController.imageURLs = product.imageURLs
        productViewController.mainImage = cell.image
        productViewController.delegate = self

        // Record in mobile analytics

        transitionToProduct(fromIndex: indexPath) { completion in
            self.present(productViewController, animated: false, completion: completion)
        }
    }
    
    // MARK: - Status Bar
    
    var statusBarHidden: Bool = false
    
    override var prefersStatusBarHidden : Bool {
        return statusBarHidden
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - Product View
    
    var activeIndexPath: IndexPath? = nil
    var activeCellFrame: CGRect? = nil
}

// MARK: - Transition

protocol FeedProductTransitionDelegate {
    func transitionToCell(fromImageFrame imageFrame: CGRect, dismissViewControllerHandler: () -> ())
}

extension FeedViewController {
    
    func transitionToProduct(fromIndex indexPath: IndexPath, presentViewHandler: @escaping (_ didFinishPresentingView: @escaping () -> ()) -> ()) {
        let window = UIApplication.shared.keyWindow
        
        let newImageView = _transition_newImageView(indexPath)
        let blackView = _transition_blackView()
        window?.addSubview(blackView)
        window?.addSubview(newImageView)
        
        newImageView.frame = _transition_getCellGlobalFrame(indexPath)
        
        let blackGradient = _transition_blackGradient()
        blackGradient.clipsToBounds = true
        blackGradient.frame = CGRect(x: 0, y: newImageView.frame.size.height - 75, width: newImageView.frame.size.width, height: 75)
        newImageView.addSubview(blackGradient)

        let imageHeight = (newImageView.image!.size.height / newImageView.image!.size.width) * self.view.frame.width
        let finalFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: imageHeight)
        let finalGradientFrame = CGRect(x: 0, y: finalFrame.size.height - 75, width: finalFrame.size.width, height: 75)
        
        statusBarHidden = true
        activeIndexPath = indexPath
        activeCellFrame = newImageView.frame
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
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
        
        let window = UIApplication.shared.keyWindow
        let newImageView = _transition_newImageView(indexPath)
        newImageView.frame = CGRect(x: imageFrame.minX, y: 0, width: imageFrame.width, height: imageFrame.height)
        let blackView = _transition_blackView()
        blackView.layer.opacity = 1.0
        
        window?.addSubview(blackView)
        window?.addSubview(newImageView)
        
        let blackGradient = _transition_blackGradient()
        blackGradient.clipsToBounds = true
        blackGradient.frame = CGRect(x: 0, y: newImageView.frame.size.height - 75, width: newImageView.frame.size.width, height: 75)
        newImageView.addSubview(blackGradient)
        
        statusBarHidden = false
        
        let finalFrame = activeCellFrame!
        let finalGradientFrame = CGRect(x: 0, y: finalFrame.size.height - 75, width: finalFrame.size.width, height: 75)
        
        dismissViewControllerHandler()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
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
    
    fileprivate func _transition_getCellGlobalFrame(_ indexPath: IndexPath) -> CGRect {
        let attributes = collectionView.layoutAttributesForItem(at: indexPath)
        let cellRect = attributes!.frame
        
        return collectionView.convert(cellRect, to: nil)
    }
    
    fileprivate func _transition_newImageView(_ indexPath: IndexPath) -> UIImageView {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FeedCell
        let image = cell.image
        
        let newImageView = UIImageView(image: image)

        return newImageView
    }
    
    fileprivate func _transition_blackGradient() -> UIView {
        let _blackGradientOverlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 75))
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.frame = _blackGradientOverlay.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        _blackGradientOverlay.layer.insertSublayer(gradient, at: 0)
        _blackGradientOverlay.clipsToBounds = true
        
        return _blackGradientOverlay
    }
    
    fileprivate func _transition_blackView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0
        view.frame = UIScreen.main.bounds
        return view
    }
}
