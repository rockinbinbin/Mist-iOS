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
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.view.frame)
        scrollView.bounces = false
        return scrollView
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.isHidden = false
        tableView.backgroundColor = UIColor.white
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var purchaseHistoryLabel: UILabel = {
        let purchaseHistoryLabel = UILabel()
        purchaseHistoryLabel.textColor = UIColor.gray
        purchaseHistoryLabel.textAlignment = .center
        purchaseHistoryLabel.lineBreakMode = .byWordWrapping
        purchaseHistoryLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "PURCHASE HISTORY")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
        
        purchaseHistoryLabel.attributedText = attrString
        purchaseHistoryLabel.font = UIFont.LatoRegularSmall()
        self.scrollView.addSubview(purchaseHistoryLabel)
        return purchaseHistoryLabel
    }()
    
    fileprivate lazy var purchasesScrollView: UIScrollView = {
        let purchasesScrollView: UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        purchasesScrollView.isPagingEnabled = true
        purchasesScrollView.alwaysBounceVertical = false
        purchasesScrollView.showsHorizontalScrollIndicator = false
        
        self.scrollView.addSubview(purchasesScrollView)
        return purchasesScrollView
    }()
    
    fileprivate lazy var headerView: UIView = {
        let headerView = UIView()
        self.scrollView.addSubview(headerView)
        return headerView
    }()
    
    internal lazy var signInButton: UIButton = {
        let signInButton = UIButton(type: .roundedRect)
        signInButton.tintColor = UIColor.white
        
        let attrString = NSMutableAttributedString(string: "SIGN IN")
        attrString.addAttribute(NSKernAttributeName, value: 4, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        signInButton.setAttributedTitle(attrString, for: UIControlState())
        self.view.addSubview(signInButton)
        
        signInButton.addTarget(self, action: #selector(AccountViewController.signInPressed), for: .touchUpInside)
        return signInButton
    }()
    
    internal lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .roundedRect)
        signUpButton.tintColor = UIColor.white
        
        let attrString = NSMutableAttributedString(string: "SIGN UP")
        attrString.addAttribute(NSKernAttributeName, value: 4, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        signUpButton.setAttributedTitle(attrString, for: UIControlState())
        self.view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(AccountViewController.signUpPressed), for: .touchUpInside)
        return signUpButton
    }()
    
    fileprivate lazy var favoritesView: UIView = {
        let favoritesView = UIView()
        
        let favoritesLabel = UILabel()
        favoritesLabel.font = UIFont.LatoRegularMedium()
        favoritesLabel.textColor = UIColor.black
        let attributedString = NSMutableAttributedString(string: "FAVORITES")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "FAVORITES".characters.count))
        favoritesLabel.attributedText = attributedString
        
        favoritesView.addSubview(favoritesLabel)
        favoritesLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 16)
        favoritesLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 32)
        
        self.scrollView.addSubview(favoritesView)
        return favoritesView
    }()
    
    fileprivate lazy var newView: UIView = {
        let newview = UIView()
        let gradientLayer = CAGradientLayer()
        
        let color1 = UIColor(red:0.13, green:0.08, blue:0.41, alpha:1.0).cgColor as CGColor
        let color2 = UIColor(red:0.85, green:0.44, blue:0.47, alpha:1.0).cgColor as CGColor
        let color3 = UIColor(red:0.95, green:0.57, blue:0.46, alpha:1.0).cgColor as CGColor
        let color4 = UIColor(red:1.0, green:0.66, blue:0.47, alpha:1.0).cgColor as CGColor
        let color5 = UIColor(red:1.0, green:0.81, blue:0.53, alpha:1.0).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.5, 0.65, 0.75, 1.0]
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        newview.layer.addSublayer(gradientLayer)
        
        self.view.addSubview(newview)
        return newview
    }()
    
    internal lazy var logOffButton: UIButton = {
        let logOffButton = UIButton(type: .roundedRect)
        logOffButton.layer.cornerRadius = 0
        logOffButton.tintColor = UIColor.black
        logOffButton.titleLabel?.font = UIFont.LatoRegularMedium()
        logOffButton.setTitle("LOG OFF", for: UIControlState())
        self.scrollView.addSubview(logOffButton)
        
        logOffButton.addTarget(self, action: #selector(AccountViewController.logOffPressed), for: .touchUpInside)
        return logOffButton
    }()
    
    internal lazy var learnMoreButton: UIButton = {
        let learnMoreButton = UIButton(type: .roundedRect)
        learnMoreButton.layer.cornerRadius = 0
        learnMoreButton.tintColor = UIColor.black
        learnMoreButton.titleLabel?.font = UIFont.LatoRegularMedium()
        learnMoreButton.setTitle("LEARN MORE", for: UIControlState())
        self.scrollView.addSubview(learnMoreButton)
        
        learnMoreButton.addTarget(self, action: #selector(AccountViewController.learnMorePressed), for: .touchUpInside)
        return learnMoreButton
    }()
    
    // end of lazy vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(scrollView)
        setNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont.LatoRegularMedium(),
            NSForegroundColorAttributeName:UIColor.black,
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "ACCOUNT", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let doneButton = ProductBarButtonItem(title: "Done", actionTarget: self, actionSelector: #selector(AccountViewController.closePressed), buttonColor: UIColor.DoneBlue())
        
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (FBSDKAccessToken.current() != nil) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 1000)
    }
    
    // MARK: - Layout
    
    func layoutViews() {
        
        let headerViewHeight: CGFloat = 195
        let gradientLayer = CAGradientLayer()
        
        headerView.pinToTopEdgeOfSuperview()
        headerView.pinToSideEdgesOfSuperview()
        headerView.sizeToHeight(headerViewHeight)
        headerView.sizeToWidth(self.view.frame.width)
        
        headerView.backgroundColor = UIColor.green
        let color1 = UIColor(red:0.13, green:0.08, blue:0.41, alpha:1.0).cgColor as CGColor
        let color2 = UIColor(red:0.85, green:0.44, blue:0.47, alpha:1.0).cgColor as CGColor
        let color3 = UIColor(red:0.95, green:0.57, blue:0.46, alpha:1.0).cgColor as CGColor
        let color4 = UIColor(red:1.0, green:0.66, blue:0.47, alpha:1.0).cgColor as CGColor
        let color5 = UIColor(red:1.0, green:0.81, blue:0.53, alpha:1.0).cgColor as CGColor
        gradientLayer.colors = [color1, color2, color3, color4, color5]
        gradientLayer.locations = [0.0, 0.5, 0.65, 0.75, 1.0]
        gradientLayer.type = kCAGradientLayerAxial
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        headerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerViewHeight)
        
        let contactImg = UIImageView()
        contactImg.image = UIImage(named: "contactImage")
        headerView.addSubview(contactImg)
        contactImg.centerHorizontallyInSuperview()
        contactImg.sizeToWidthAndHeight(76)
        contactImg.pinToTopEdgeOfSuperview(offset: 36)
        
        let accountLabel = UILabel()
        accountLabel.font = UIFont.LatoRegularMedium()
        accountLabel.textColor = UIColor.white
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
    
    internal func decorateImage(_ imageView: UIImageView?, gifView: FLAnimatedImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.white
            decorateLabel.textAlignment = .center
            decorateLabel.lineBreakMode = .byWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: "Alpaca Sweater")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
            decorateLabel.attributedText = attrString
            self.scrollView.addSubview(decorateLabel)
            return decorateLabel
        }()
        
        let bottomView: UIView = {
            let bottomView = UIView()
            bottomView.backgroundColor = UIColor.black
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
            imageView?.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    internal func setImages(_ images: NSArray) {
        var productImageView : UIImageView
        var productGifView : FLAnimatedImageView
        
        let numImages = CGFloat(images.count)
        
        // + 20 is for padding on left side
        purchasesScrollView.contentSize = CGSize(width: 210 * numImages + 20, height: 200)
        
        var count = 0
        
        for image in images {
            if let img = image as? UIImage {
                // image
                productImageView = UIImageView(image: img)
                let floatCount = CGFloat(count)
                // + 20 is for padding on left side
                productImageView.frame = CGRect(x: floatCount * 210 + 20, y: 0, width: 200, height: 200)
                productImageView.contentMode = .scaleAspectFit
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
                    productGifView.frame = CGRect(x: floatCount * 210 + 20, y: 0, width: 200, height: 200)
                    productGifView.contentMode = .scaleAspectFit
                    productGifView.layer.cornerRadius = 3
                    purchasesScrollView.addSubview(productGifView)
                    decorateImage(nil, gifView: productGifView)
                }
            }
            count += 1;
        }
    }
    
    func didLoadAddresses(_ objects: [AnyObject]!) {
        if let objects = objects {
            userAddresses = objects as NSArray
        }
    }
    
    // MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "productCell"
        var cell: AccountSettingsCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? AccountSettingsCell
        
        //cell?.layoutSubviews()
        
        if cell == nil {
            cell = AccountSettingsCell()
            cell?.selectionStyle = .none
        }
        
        if (indexPath.row == 0) {
            cell?.imgView.image = UIImage(named: "wallet")
            
            let attrString = NSMutableAttributedString(string: "PAYMENT METHOD")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
            
            cell!.titleLabel.attributedText = attrString
            
            let attrString2 = NSMutableAttributedString(string: "APPLE PAY")
            attrString2.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString2.length))
            attrString2.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString2.length))
            
            cell!.detail.attributedText = attrString2
        }
        
        if (indexPath.row == 1) {
            cell?.imgView.image = UIImage(named: "box")
            let attrString = NSMutableAttributedString(string: "SHIPPING ADDRESS")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
            
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
            attrString2.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString2.length))
            
            cell!.detail.attributedText = attrString2
        }
        
        if (indexPath.row == 2) {
            cell?.imgView.image = UIImage(named: "chat")
            let attrString = NSMutableAttributedString(string: "CONTACT US")
            attrString.addAttribute(NSKernAttributeName, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSFontAttributeName, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
            
            cell!.titleLabel.attributedText = attrString
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Shipping address
        if (indexPath.row == 1) {
            AnalyticsManager.sharedInstance.recordEvent(Event.Account.shippingAddressPressed)
            
            let shipVC = ShippingViewController()
            shipVC.userAddresses = userAddresses
            self.navigationController?.pushViewController(shipVC, animated: true)
        }
        if (indexPath.row == 2) {
            sendEmailButtonTapped()
        }
    }
    
    func tableView(_ _tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                                   forRowAt indexPath: IndexPath) {
        
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    internal func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Status bar hiding
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .slide
    }
    
    func signInPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.signInPressed)
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    func signUpPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.signUpPressed)
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    func logOffPressed() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.logOutPressed)
        if (FBSDKAccessToken.current() != nil) {
            FBSDKAccessToken.setCurrent(nil)
            
            self.layoutNotLoggedInView()
        }
    }
    
    func learnMorePressed() {
        // push new info guide vc 
        self.navigationController?.pushViewController(SustainabilityGuideViewController(), animated: true)
        
    }
    
    
    func sendEmailButtonTapped() {
        AnalyticsManager.sharedInstance.recordEvent(Event.Account.contactUsPressed)
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
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
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    

}
