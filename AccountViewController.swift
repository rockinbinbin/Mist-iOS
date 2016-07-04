//
//  AccountViewController.swift
//  Mist
//
//  Created by Robin Mehta on 6/17/16.
//
//

import UIKit
import MessageUI
import FLAnimatedImage
import FBSDKLoginKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {

    var userAddresses = NSArray()
    let tempImages = NSArray(objects: UIImage(named: "alpaca_2")!, UIImage(named: "alpaca_3")!, UIImage(named: "alpacaSweater")!)
    
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.view.frame)
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollEnabled = false
        tableView.hidden = false
        tableView.backgroundColor = UIColor.whiteColor()
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var purchaseHistoryLabel: UILabel = {
        let purchaseHistoryLabel = UILabel()
        purchaseHistoryLabel.textColor = UIColor.grayColor()
        purchaseHistoryLabel.textAlignment = .Center
        purchaseHistoryLabel.lineBreakMode = .ByWordWrapping
        purchaseHistoryLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "PURCHASE HISTORY")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
        
        purchaseHistoryLabel.attributedText = attrString
        purchaseHistoryLabel.font = UIFont(name: "Lato-Regular", size: 15)
        self.scrollView.addSubview(purchaseHistoryLabel)
        return purchaseHistoryLabel
    }()
    
    private lazy var purchasesScrollView: UIScrollView = {
        let purchasesScrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, 100))
        purchasesScrollView.pagingEnabled = true
        purchasesScrollView.alwaysBounceVertical = false
        purchasesScrollView.showsHorizontalScrollIndicator = false
        
        self.scrollView.addSubview(purchasesScrollView)
        return purchasesScrollView
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView()
        self.scrollView.addSubview(headerView)
        return headerView
    }()
    
    internal lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .RoundedRect)
        signInButton.tintColor = UIColor.whiteColor()
        
        let attrString = NSMutableAttributedString(string: "SIGN IN")
        attrString.addAttribute(NSKernAttributeName, value: 4, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 18)!, range: NSMakeRange(0, attrString.length))
        
        signInButton.setAttributedTitle(attrString, forState: .Normal)
        self.view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(AccountViewController.signInPressed), forControlEvents: .TouchUpInside)
        return signInButton
    }()
    
    internal lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .RoundedRect)
        signUpButton.tintColor = UIColor.whiteColor()
        
        let attrString = NSMutableAttributedString(string: "SIGN UP")
        attrString.addAttribute(NSKernAttributeName, value: 4, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 18)!, range: NSMakeRange(0, attrString.length))
        
        signUpButton.setAttributedTitle(attrString, forState: .Normal)
        self.view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(AccountViewController.signUpPressed), forControlEvents: .TouchUpInside)
        return signUpButton
    }()
    
    private lazy var favoritesView: UIView = {
        let favoritesView = UIView()
        
        let favoritesLabel = UILabel()
        favoritesLabel.font = UIFont(name: "Lato-Light", size: 22.0)
        favoritesLabel.textColor = UIColor.blackColor()
        let attributedString = NSMutableAttributedString(string: "FAVORITES")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "FAVORITES".characters.count))
        favoritesLabel.attributedText = attributedString
        
        favoritesView.addSubview(favoritesLabel)
        favoritesLabel.pinToTopEdgeOfSuperview(offset: 16)
        favoritesLabel.pinToLeftEdgeOfSuperview(offset: 32)
        
        self.scrollView.addSubview(favoritesView)
        return favoritesView
    }()
    
    private lazy var newView: UIView = {
        let newview = UIView()
        let gradientLayer = CAGradientLayer()
        
        let color1 = UIColor(red:0.13, green:0.08, blue:0.41, alpha:1.0).CGColor as CGColorRef
        let color2 = UIColor(red:0.85, green:0.44, blue:0.47, alpha:1.0).CGColor as CGColorRef
        let color3 = UIColor(red:0.95, green:0.57, blue:0.46, alpha:1.0).CGColor as CGColorRef
        let color4 = UIColor(red:1.0, green:0.66, blue:0.47, alpha:1.0).CGColor as CGColorRef
        let color5 = UIColor(red:1.0, green:0.81, blue:0.53, alpha:1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.5, 0.65, 0.75, 1.0]
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1.0, 1)
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        newview.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(newview)
        return newview
    }()
    
    internal lazy var logOffButton: UIButton = {
        let logOffButton = UIButton(type: .RoundedRect)
        logOffButton.layer.cornerRadius = 0
        logOffButton.tintColor = UIColor.blackColor()
        logOffButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        logOffButton.setTitle("LOG OFF", forState: .Normal)
        self.scrollView.addSubview(logOffButton)
        
        logOffButton.addTarget(self, action: #selector(AccountViewController.logOffPressed), forControlEvents: .TouchUpInside)
        return logOffButton
    }()
    
    internal lazy var learnMoreButton: UIButton = {
        let learnMoreButton = UIButton(type: .RoundedRect)
        learnMoreButton.layer.cornerRadius = 0
        learnMoreButton.tintColor = UIColor.blackColor()
        learnMoreButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 20)
        learnMoreButton.setTitle("LEARN MORE", forState: .Normal)
        self.scrollView.addSubview(learnMoreButton)
        
        learnMoreButton.addTarget(self, action: #selector(AccountViewController.learnMorePressed), forControlEvents: .TouchUpInside)
        return learnMoreButton
    }()
    
    // end of lazy vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollView)
        setNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Bold", size: 16)!,
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "ACCOUNT", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let doneButton = ProductBarButtonItem(title: "Done", actionTarget: self, actionSelector: #selector(AccountViewController.closePressed), buttonColor: Constants.Colors.DoneBlue)
        
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // logged in
            self.layoutViews()
        }
        else {
            // show login view
            self.layoutNotLoggedInView()
        }
    }
    
    func layoutNotLoggedInView() {
        
        newView.pinToEdgesOfSuperview()
        newView.sizeToHeight(self.view.frame.size.height)
        newView.sizeToWidth(self.view.frame.size.width)
        
        signInButton.centerHorizontallyInSuperview()
        signInButton.centerVerticallyInSuperview(offset: -20)
        signUpButton.centerHorizontallyInSuperview()
        signUpButton.centerVerticallyInSuperview(offset: 20)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSizeMake(self.view.frame.width, 1000)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        
        let headerViewHeight: CGFloat = 195
        let gradientLayer = CAGradientLayer()
        
        headerView.pinToTopEdgeOfSuperview()
        headerView.pinToSideEdgesOfSuperview()
        headerView.sizeToHeight(headerViewHeight)
        headerView.sizeToWidth(self.view.frame.width)
        
        headerView.backgroundColor = UIColor.greenColor()
        let color1 = UIColor(red:0.13, green:0.08, blue:0.41, alpha:1.0).CGColor as CGColorRef
        let color2 = UIColor(red:0.85, green:0.44, blue:0.47, alpha:1.0).CGColor as CGColorRef
        let color3 = UIColor(red:0.95, green:0.57, blue:0.46, alpha:1.0).CGColor as CGColorRef
        let color4 = UIColor(red:1.0, green:0.66, blue:0.47, alpha:1.0).CGColor as CGColorRef
        let color5 = UIColor(red:1.0, green:0.81, blue:0.53, alpha:1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.5, 0.65, 0.75, 1.0]
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1.0, 1)
        headerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRectMake(0, 0, self.view.frame.width, headerViewHeight)
        
        let contactImg = UIImageView()
        contactImg.image = UIImage(named: "contactImage")
        headerView.addSubview(contactImg)
        contactImg.centerHorizontallyInSuperview()
        contactImg.sizeToWidthAndHeight(76)
        contactImg.pinToTopEdgeOfSuperview(offset: 36)
        
        let accountLabel = UILabel()
        accountLabel.font = UIFont(name: "Lato-Bold", size: 16.0)
        accountLabel.textColor = UIColor.whiteColor()
//        let emailStr = PFUser.currentUser()?.objectForKey("email") as! String
        let emailStr = "robinmehta94@gmail.com"
        let attributedString = NSMutableAttributedString(string: emailStr)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(0), range: NSRange(location: 0, length: emailStr.characters.count))
        accountLabel.attributedText = attributedString
        
        headerView.addSubview(accountLabel)
        accountLabel.positionBelowItem(contactImg, offset: 18)
        accountLabel.centerHorizontallyInSuperview()
        
        let waves = UIImageView(image: UIImage(named: "Account-Waves"))
        headerView.addSubview(waves)
        waves.pinToBottomEdgeOfSuperview()
        waves.pinToSideEdgesOfSuperview()
        waves.sizeToHeight(33)
        
        tableView.positionBelowItem(headerView, offset: 20)
        tableView.pinToLeftEdgeOfSuperview()
        tableView.pinToRightEdgeOfSuperview()
        tableView.sizeToHeight(150)
        
        purchaseHistoryLabel.positionBelowItem(tableView, offset: 20)
        purchaseHistoryLabel.pinToLeftEdgeOfSuperview(offset: 20)
        
        purchasesScrollView.positionBelowItem(purchaseHistoryLabel, offset: 10)
        purchasesScrollView.pinToLeftEdgeOfSuperview()
        purchasesScrollView.pinToRightEdgeOfSuperview()
        purchasesScrollView.sizeToWidth(self.view.frame.size.width)
        purchasesScrollView.sizeToHeight(200)
        
        setImages(tempImages)
        
        logOffButton.positionBelowItem(purchasesScrollView, offset: 100)
        logOffButton.centerHorizontallyInSuperview()
        
        learnMoreButton.positionBelowItem(logOffButton, offset: 100)
        learnMoreButton.centerHorizontallyInSuperview()
    }
    
    internal func decorateImage(imageView: UIImageView?, gifView: FLAnimatedImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.whiteColor()
            decorateLabel.textAlignment = .Center
            decorateLabel.lineBreakMode = .ByWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: "Alpaca Sweater")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 10)!, range: NSMakeRange(0, attrString.length))
            
            decorateLabel.attributedText = attrString
            decorateLabel.font = UIFont(name: "Lato-Regular", size: 15)
            self.scrollView.addSubview(decorateLabel)
            return decorateLabel
        }()
        
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = UIColor.blackColor()
            bottomView.layer.cornerRadius = 3
            return bottomView
        }()
        
        if (imageView?.image != nil) {
            imageView?.addSubview(bottomView)
            bottomView.pinToBottomEdgeOfSuperview()
            bottomView.pinToLeftEdgeOfSuperview()
            bottomView.pinToRightEdgeOfSuperview()
            bottomView.sizeToHeight(30)
            
            bottomView.addSubview(decorateLabel)
            decorateLabel.pinToLeftEdgeOfSuperview(offset: 10)
            decorateLabel.centerVerticallyInSuperview()
            
            imageView?.layer.borderWidth = 0.5
            imageView?.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
    }
    
    internal func setImages(images: NSArray) {
        var productImageView : UIImageView
        var productGifView : FLAnimatedImageView
        
        let numImages = CGFloat(images.count)
        
        // + 20 is for padding on left side
        purchasesScrollView.contentSize = CGSizeMake(210 * numImages + 20, 200)
        
        var count = 0
        
        for image in images {
            if let img = image as? UIImage {
                // image
                productImageView = UIImageView(image: img)
                let floatCount = CGFloat(count)
                // + 20 is for padding on left side
                productImageView.frame = CGRectMake(floatCount * 210 + 20, 0, 200, 200)
                productImageView.contentMode = .ScaleAspectFit
                productImageView.layer.cornerRadius = 3
                purchasesScrollView.addSubview(productImageView)
                decorateImage(productImageView, gifView: nil)
            }
            else {
                // GIF
                if let gif = image as? FLAnimatedImage {
                    productGifView = FLAnimatedImageView()
                    productGifView.animatedImage = gif
                    let floatCount = CGFloat(count)
                    // + 20 is for padding on left side
                    productGifView.frame = CGRectMake(floatCount * 210 + 20, 0, 200, 200)
                    productGifView.contentMode = .ScaleAspectFit
                    productGifView.layer.cornerRadius = 3
                    purchasesScrollView.addSubview(productGifView)
                    decorateImage(nil, gifView: productGifView)
                }
            }
            count += 1;
        }
    }
    
    func didLoadAddresses(objects: [AnyObject]!) {
        if let objects = objects {
            userAddresses = objects
        }
    }
    
    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "productCell"
        var cell: AccountSettingsCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? AccountSettingsCell
        
        //cell?.layoutSubviews()
        
        if cell == nil {
            cell = AccountSettingsCell()
            cell?.selectionStyle = .None
        }
        
        if (indexPath.row == 0) {
            cell?.imgView.image = UIImage(named: "wallet")
            
            let attrString = NSMutableAttributedString(string: "PAYMENT METHOD")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
            
            cell!.titleLabel.attributedText = attrString
            
            let attrString2 = NSMutableAttributedString(string: "APPLE PAY")
            attrString2.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString2.length))
            attrString2.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString2.length))
            
            cell!.detail.attributedText = attrString2
        }
        
        if (indexPath.row == 1) {
            cell?.imgView.image = UIImage(named: "box")
            let attrString = NSMutableAttributedString(string: "SHIPPING ADDRESS")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
            
            cell!.titleLabel.attributedText = attrString
            
//            let defaultObj : PFObject = PFUser.currentUser()!.objectForKey("defaultAddress") as! PFObject
            
//            defaultObj.fetchIfNeededInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
//                let attrString2 = NSMutableAttributedString(string: (object?.objectForKey("Name"))! as! String)
//                attrString2.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString2.length))
//                attrString2.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString2.length))
//                
//                cell!.detail.attributedText = attrString2
//            })
            
            let attrString2 = NSMutableAttributedString(string: "321 Stonytown Road")
            attrString2.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString2.length))
            attrString2.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString2.length))
            
            cell!.detail.attributedText = attrString2
        }
        
        if (indexPath.row == 2) {
            cell?.imgView.image = UIImage(named: "chat")
            let attrString = NSMutableAttributedString(string: "CONTACT US")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
            
            cell!.titleLabel.attributedText = attrString
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Shipping address
        if (indexPath.row == 1) {
            AnalyticsManager.sharedInstance.recordEvent(Event.Account.ShippingAddressPressed)
            
            let shipVC = ShippingViewController()
            shipVC.userAddresses = userAddresses
            self.navigationController?.pushViewController(shipVC, animated: true)
        }
        if (indexPath.row == 2) {
            sendEmailButtonTapped()
        }
    }
    
    func tableView(_tableView: UITableView,
                   willDisplayCell cell: UITableViewCell,
                                   forRowAtIndexPath indexPath: NSIndexPath) {
        
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    internal func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Status bar hiding
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Slide
    }
    
    func signInPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.SignInPressed)
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    func signUpPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.SignUpPressed)
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func logOffPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.LogOutPressed)
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKAccessToken.setCurrentAccessToken(nil)
            
            self.layoutNotLoggedInView()
        }
    }
    
    func learnMorePressed() {
        // push new info guide vc 
        self.navigationController?.pushViewController(SustainabilityGuideViewController(), animated: true)
        
    }
    
    
    func sendEmailButtonTapped() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.ContactUsPressed)
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["team@bounceho.me"])
        mailComposerVC.setSubject("Hi there!")
        mailComposerVC.setMessageBody("👋👋👋", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    

}
