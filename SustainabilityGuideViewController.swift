//
//  SustainabilityGuideViewController.swift
//  Mist
//
//  Created by Robin Mehta on 6/22/16.
//
//

import UIKit

class SustainabilityGuideViewController: UIViewController {
    
    // UI 
    
    internal lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.textAlignment = .Left
        headerLabel.lineBreakMode = .ByWordWrapping
        headerLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "here's to ")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 20)!, range: NSMakeRange(0, attrString.length))
        
        headerLabel.attributedText = attrString
        self.view.addSubview(headerLabel)
        return headerLabel
    }()
    
    internal lazy var updatingHeaderLabel: UILabel = {
        let updatingHeaderLabel = UILabel()
        updatingHeaderLabel.textColor = UIColor.whiteColor()
        updatingHeaderLabel.textAlignment = .Left
        updatingHeaderLabel.lineBreakMode = .ByWordWrapping
        updatingHeaderLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: " beautiful")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 20)!, range: NSMakeRange(0, attrString.length))
        
        updatingHeaderLabel.attributedText = attrString
        self.view.addSubview(updatingHeaderLabel)
        return updatingHeaderLabel
    }()
    
    internal lazy var thankYouLabel: UILabel = {
        let thankYouLabel = UILabel()
        thankYouLabel.textColor = UIColor.lightGrayColor()
        thankYouLabel.textAlignment = .Left
        thankYouLabel.lineBreakMode = .ByWordWrapping
        thankYouLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "Thank you.")
        attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 16)!, range: NSMakeRange(0, attrString.length))
        
        thankYouLabel.attributedText = attrString
        self.view.addSubview(thankYouLabel)
        return thankYouLabel
    }()
    
    internal lazy var appreciateLabel: UILabel = {
        let appreciateLabel = UILabel()
        appreciateLabel.textColor = UIColor.lightGrayColor()
        appreciateLabel.textAlignment = .Left
        appreciateLabel.lineBreakMode = .ByWordWrapping
        appreciateLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We appreciate you.")
        attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 16)!, range: NSMakeRange(0, attrString.length))
        
        appreciateLabel.attributedText = attrString
        self.view.addSubview(appreciateLabel)
        return appreciateLabel
    }()
    
    internal lazy var supportLabel: UILabel = {
        let supportLabel = UILabel()
        supportLabel.textColor = UIColor.lightGrayColor()
        supportLabel.textAlignment = .Left
        supportLabel.lineBreakMode = .ByWordWrapping
        supportLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We're here to support you & your lifestyle.")
        attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 16)!, range: NSMakeRange(0, attrString.length))
        
        supportLabel.attributedText = attrString
        self.view.addSubview(supportLabel)
        return supportLabel
    }()
    
    internal lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.textColor = UIColor.whiteColor()
        bodyLabel.textAlignment = .Left
        bodyLabel.lineBreakMode = .ByWordWrapping
        bodyLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "MIST does the work of curating brands who value transparency, so you can clear your conscience, effortlessly.")
        attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 14)!, range: NSMakeRange(0, attrString.length))
        
        bodyLabel.attributedText = attrString
        self.view.addSubview(bodyLabel)
        return bodyLabel
    }()
    
    internal lazy var body2Label: UILabel = {
        let body2Label = UILabel()
        body2Label.textColor = UIColor.whiteColor()
        body2Label.textAlignment = .Left
        body2Label.lineBreakMode = .ByWordWrapping
        body2Label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We curate sustainably-made, long-lasting pieces designed by creatives who put quality & our rivers first, so that you can feel good about what you wear.")
        attrString.addAttribute(NSKernAttributeName, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 14)!, range: NSMakeRange(0, attrString.length))
        
        body2Label.attributedText = attrString
        self.view.addSubview(body2Label)
        return body2Label
    }()
    
    internal lazy var nextPageButton: UIButton = {
        let nextPageButton = UIButton(type: .RoundedRect)
        nextPageButton.layer.cornerRadius = 0
        nextPageButton.tintColor = UIColor.whiteColor()
        nextPageButton.layer.borderColor = UIColor.whiteColor().CGColor
        nextPageButton.layer.borderWidth = 1.0
        nextPageButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 15)
        nextPageButton.setTitle("   Skim our guide on transparency →   ", forState: .Normal)
        self.view.addSubview(nextPageButton)
        
        nextPageButton.addTarget(self, action: #selector(SustainabilityGuideViewController.nextPagePressed), forControlEvents: .TouchUpInside)
        return nextPageButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.Colors.DarkBlue
        setNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutViews()
    }
    
    func layoutViews() {
        headerLabel.pinToTopEdgeOfSuperview(offset: 100)
        headerLabel.pinToLeftEdgeOfSuperview(offset: 20)
        updatingHeaderLabel.positionToTheRightOfItem(headerLabel, offset: 0)
        updatingHeaderLabel.pinToTopEdgeOfSuperview(offset: 100)
        
        let img = UIImageView()
        img.image = UIImage(named: "girl")
        self.view.addSubview(img)
        img.pinToRightEdgeOfSuperview(offset: 20)
        img.positionBelowItem(headerLabel, offset: 20)
        
        thankYouLabel.pinToLeftEdgeOfSuperview(offset: 20)
        thankYouLabel.positionBelowItem(headerLabel, offset: 50)
        
        appreciateLabel.pinToLeftEdgeOfSuperview(offset: 20)
        appreciateLabel.positionBelowItem(thankYouLabel, offset: 30)
        
        supportLabel.pinToLeftEdgeOfSuperview(offset: 20)
        supportLabel.sizeToWidth(150)
        supportLabel.positionBelowItem(appreciateLabel, offset: 30)
        
        bodyLabel.positionBelowItem(img, offset: 20)
        bodyLabel.pinToLeftEdgeOfSuperview(offset: 20)
        bodyLabel.sizeToWidth(self.view.frame.size.width - 50)
        
        body2Label.positionBelowItem(bodyLabel, offset: 20)
        body2Label.pinToLeftEdgeOfSuperview(offset: 20)
        body2Label.sizeToWidth(self.view.frame.size.width - 50)
        
        nextPageButton.pinToBottomEdgeOfSuperview(offset: 50)
        nextPageButton.centerHorizontallyInSuperview()
        
        self.startUpdatingLabel()
    }
    
    func startUpdatingLabel() {
        NSTimer.scheduledTimerWithTimeInterval(0, target: self, selector: #selector(SustainabilityGuideViewController.updateLabel(_:)), userInfo: 0, repeats: false)
    }
    
    func updateLabel(timer: NSTimer) {
        
        let array = ["the creatives", "the eco-conscious", "the questioners", "the curious", "you"]
        
        let index = timer.userInfo?.integerValue
        if (index >= array.count) {
            return;
        }
        
        let attrString = NSMutableAttributedString(string: array[index!])
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 20)!, range: NSMakeRange(0, attrString.length))
        
        updatingHeaderLabel.attributedText = attrString
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SustainabilityGuideViewController.updateLabel), userInfo: index!+1, repeats: false)
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
        
        let attributedTitle = NSAttributedString(string: "ABOUT US", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let doneButton = ProductBarButtonItem(title: "Done", actionTarget: self, actionSelector: #selector(SustainabilityGuideViewController.closePressed), buttonColor: Constants.Colors.DoneBlue)
        
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    internal func closePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func nextPagePressed() {
        // push sustainability info guide
    }

}
