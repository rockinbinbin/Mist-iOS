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
import PureLayout

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, MFMailComposeViewControllerDelegate {

    var userAddresses = NSArray()
    let tempImages = NSArray(objects: UIImage(named: "test.jpg")!, UIImage(named: "test.jpg")!, UIImage(named: "test.jpg")!)
    
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
        tableView.styleTableView()
        self.scrollView.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var purchaseHistoryLabel: UILabel = {
        let purchaseHistoryLabel = UILabel()
        purchaseHistoryLabel.styleGrayLabel("PURCHASE HISTORY")
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
        attrString.styleText("SIGN IN")
        signInButton.setAttributedTitle(attrString, for: UIControlState())
        self.view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(AccountViewController.signInPressed), for: .touchUpInside)
        return signInButton
    }()
    
    internal lazy var signUpButton: UIButton = {
        let signUpButton = UIButton(type: .roundedRect)
        signUpButton.tintColor = UIColor.white
        let attrString = NSMutableAttributedString(string: "SIGN UP")
        attrString.styleText("SIGN UP")
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
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(4), range: NSRange(location: 0, length: "FAVORITES".count))
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
        gradientLayer.createPlumGradient()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        newview.layer.addSublayer(gradientLayer)
        self.view.addSubview(newview)
        return newview
    }()
    
    internal lazy var logOffButton: UIButton = {
        let logOffButton = UIButton(type: .roundedRect)
        logOffButton.styleButton("LOG OFF")
        self.scrollView.addSubview(logOffButton)
        logOffButton.addTarget(self, action: #selector(AccountViewController.logOffPressed), for: .touchUpInside)
        return logOffButton
    }()
    
    internal lazy var learnMoreButton: UIButton = {
        let learnMoreButton = UIButton(type: .roundedRect)
        learnMoreButton.styleButton("LEARN MORE")
        self.scrollView.addSubview(learnMoreButton)
        learnMoreButton.addTarget(self, action: #selector(AccountViewController.learnMorePressed), for: .touchUpInside)
        return learnMoreButton
    }()

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
        let attributedTitle = NSMutableAttributedString(string: "ACCOUNT")
        attributedTitle.styleText("ACCOUNT")
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        let doneButton = ProductBarButtonItem(title: "Done", actionTarget: self, actionSelector: #selector(AccountViewController.closePressed), buttonColor: UIColor.DoneBlue())
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (FBSDKAccessToken.current() != nil) ? self.layoutViews() : self.layoutNotLoggedInView()
    }

    let carouselImageView = UIImageView(image: UIImage(named: "1.jpg"))
    var index = 0
    let imageArray = [UIImage(named: "main.jpg"), UIImage(named: "2.jpg"), UIImage(named: "3.jpg"), UIImage(named: "4.jpg"), UIImage(named: "5.jpg"), UIImage(named: "6.jpg"), UIImage(named: "7.jpg"), UIImage(named: "8.jpg"), UIImage(named: "9.jpg")]
    
    func loadImage(){
        if (index >= imageArray.count) {
            index = 0
        }
        UIView.transition(with: self.carouselImageView,
                                  duration:5,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: { self.carouselImageView.image = self.imageArray[self.index] },
                                  completion: { (success) in
                                    self.loadImage() })
        index += 1
    }
    
    func layoutNotLoggedInView() {
        newView.autoPinEdgesToSuperviewEdges()
        newView.autoSetDimensions(to: self.view.frame.size)

        carouselImageView.contentMode = .scaleAspectFill
        newView.addSubview(carouselImageView)
        carouselImageView.autoPinEdgesToSuperviewEdges()
        carouselImageView.autoSetDimensions(to: self.view.frame.size)

        loadImage()

//        var timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: Selector(("loadImage")), userInfo: nil, repeats: true)

        let blackLayer = CALayer()
        blackLayer.backgroundColor = UIColor.white.cgColor
        blackLayer.opacity = 0.5
        carouselImageView.layer.addSublayer(blackLayer)
        blackLayer.frame = carouselImageView.frame

        signInButton.autoAlignAxis(toSuperviewAxis: .vertical)
        signInButton.autoAlignAxis(.horizontal, toSameAxisOf: self.view, withOffset: -20)
        signUpButton.autoAlignAxis(toSuperviewAxis: .vertical)
        signUpButton.autoAlignAxis(.horizontal, toSameAxisOf: self.view, withOffset: 20)
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
        headerView.autoPinEdge(toSuperviewEdge: .top)
        headerView.autoPinEdge(toSuperviewEdge: .left)
        headerView.autoPinEdge(toSuperviewEdge: .right)
        headerView.autoSetDimensions(to: CGSize(width: self.view.frame.width, height: headerViewHeight))
        let gradientLayer = CAGradientLayer()
        gradientLayer.createPlumGradient()
        headerView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: headerViewHeight)
        
        let contactImg = UIImageView()
        contactImg.image = UIImage(named: "contactImage")
        headerView.addSubview(contactImg)

        contactImg.autoAlignAxis(toSuperviewAxis: .vertical)
        contactImg.autoSetDimensions(to: CGSize(width: 76, height: 76))
        contactImg.autoPinEdge(.top, to: .top, of: headerView, withOffset: 36)

        let accountLabel = UILabel()
        accountLabel.font = UIFont.LatoRegularMedium()
        accountLabel.textColor = UIColor.white
        let emailStr = "robinmehta94@gmail.com"
        let attributedString = NSMutableAttributedString(string: emailStr)
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(0), range: NSRange(location: 0, length: emailStr.count))
        accountLabel.attributedText = attributedString
        
        headerView.addSubview(accountLabel)
        accountLabel.positionBelowItem(contactImg, offset: 18)
        accountLabel.autoAlignAxis(toSuperviewAxis: .vertical)

        let waves = UIImageView(image: UIImage(named: "Account-Waves"))
        headerView.addSubview(waves)

        waves.autoPinEdge(toSuperviewEdge: .bottom)
        waves.autoPinEdge(toSuperviewEdge: .left)
        waves.autoPinEdge(toSuperviewEdge: .right)
        waves.autoSetDimension(.height, toSize: 33)

        tableView.positionBelowItem(headerView, offset: 20)
        tableView.autoPinEdge(toSuperviewEdge: .left)
        tableView.autoPinEdge(toSuperviewEdge: .right)
        tableView.autoSetDimension(.height, toSize: 150)

        purchaseHistoryLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 20)
        purchaseHistoryLabel.positionBelowItem(tableView, offset: 20)

        purchasesScrollView.autoPinEdge(toSuperviewEdge: .left)
        purchasesScrollView.autoPinEdge(toSuperviewEdge: .right)
        purchasesScrollView.autoSetDimensions(to: CGSize(width: self.view.frame.size.width, height: 200))
        purchasesScrollView.positionBelowItem(purchaseHistoryLabel, offset: 10)
        
        setImages(tempImages)
        
        logOffButton.positionBelowItem(purchasesScrollView, offset: 100)
        logOffButton.autoAlignAxis(toSuperviewAxis: .vertical)

        learnMoreButton.positionBelowItem(logOffButton, offset: 100)
        learnMoreButton.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    internal func decorateImage(_ imageView: UIImageView?, gifView: FLAnimatedImageView?) {
        
        let decorateLabel: UILabel = {
            let decorateLabel = UILabel()
            decorateLabel.textColor = UIColor.white
            decorateLabel.textAlignment = .center
            decorateLabel.lineBreakMode = .byWordWrapping
            decorateLabel.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: "Daypack1")
            attrString.addAttribute(NSAttributedStringKey.kern, value: 1, range: NSMakeRange(0, attrString.length))
            attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
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

            bottomView.autoPinEdge(toSuperviewEdge: .bottom)
            bottomView.autoPinEdge(toSuperviewEdge: .left)
            bottomView.autoPinEdge(toSuperviewEdge: .right)
            bottomView.autoSetDimension(.height, toSize: 30)
            
            bottomView.addSubview(decorateLabel)

            decorateLabel.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
            decorateLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
            
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

        if cell == nil {
            cell = AccountSettingsCell()
            cell?.selectionStyle = .none
        }
        if (indexPath.row == 0) {
            cell?.imgView.image = UIImage(named: "wallet")
            
            let attrString = NSMutableAttributedString(string: "PAYMENT METHOD")
            attrString.styleText("PAYMENT METHOD")
            cell!.titleLabel.attributedText = attrString
            
            let attrString2 = NSMutableAttributedString(string: "APPLE PAY")
            attrString2.styleText("APPLE PAY")
            cell!.detail.attributedText = attrString2
        }
        if (indexPath.row == 1) {
            cell?.imgView.image = UIImage(named: "box")
            let attrString = NSMutableAttributedString(string: "SHIPPING ADDRESS")
            attrString.styleText("SHIPPING ADDRESS")
            cell!.titleLabel.attributedText = attrString
            
            let attrString2 = NSMutableAttributedString(string: "321 Stonytown Road")
            attrString2.styleText("321 Stonytown Road")
            cell!.detail.attributedText = attrString2
        }
        if (indexPath.row == 2) {
            cell?.imgView.image = UIImage(named: "chat")
            let attrString = NSMutableAttributedString(string: "CONTACT US")
            attrString.styleText("CONTACT US")
            cell!.titleLabel.attributedText = attrString
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Shipping address
        if (indexPath.row == 1) {
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
    
    @objc internal func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Status bar hiding
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .slide
    }
    
    @objc func signInPressed() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
    
    @objc func signUpPressed() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func logOffPressed() {
        if (FBSDKAccessToken.current() != nil) {
            FBSDKAccessToken.setCurrent(nil)
            self.layoutNotLoggedInView()
        }
    }
    
    @objc func learnMorePressed() {
        self.navigationController?.pushViewController(SustainabilityGuideViewController(), animated: true)
        
    }
    
    
    func sendEmailButtonTapped() {
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
