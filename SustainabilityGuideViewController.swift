//
//  SustainabilityGuideViewController.swift
//  Mist
//
//  Created by Robin Mehta on 6/22/16.
//
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class SustainabilityGuideViewController: UIViewController {
    
    // UI 
    
    internal lazy var headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .left
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "here's to ")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        headerLabel.attributedText = attrString
        self.view.addSubview(headerLabel)
        return headerLabel
    }()
    
    internal lazy var updatingHeaderLabel: UILabel = {
        let updatingHeaderLabel = UILabel()
        updatingHeaderLabel.textColor = UIColor.white
        updatingHeaderLabel.textAlignment = .left
        updatingHeaderLabel.lineBreakMode = .byWordWrapping
        updatingHeaderLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: " beautiful")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        updatingHeaderLabel.attributedText = attrString
        self.view.addSubview(updatingHeaderLabel)
        return updatingHeaderLabel
    }()
    
    internal lazy var thankYouLabel: UILabel = {
        let thankYouLabel = UILabel()
        thankYouLabel.textColor = UIColor.lightGray
        thankYouLabel.textAlignment = .left
        thankYouLabel.lineBreakMode = .byWordWrapping
        thankYouLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "Thank you.")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        thankYouLabel.attributedText = attrString
        self.view.addSubview(thankYouLabel)
        return thankYouLabel
    }()
    
    internal lazy var appreciateLabel: UILabel = {
        let appreciateLabel = UILabel()
        appreciateLabel.textColor = UIColor.lightGray
        appreciateLabel.textAlignment = .left
        appreciateLabel.lineBreakMode = .byWordWrapping
        appreciateLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We appreciate you.")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        appreciateLabel.attributedText = attrString
        self.view.addSubview(appreciateLabel)
        return appreciateLabel
    }()
    
    internal lazy var supportLabel: UILabel = {
        let supportLabel = UILabel()
        supportLabel.textColor = UIColor.lightGray
        supportLabel.textAlignment = .left
        supportLabel.lineBreakMode = .byWordWrapping
        supportLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We're here to support you & your lifestyle.")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        supportLabel.attributedText = attrString
        self.view.addSubview(supportLabel)
        return supportLabel
    }()
    
    internal lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.textColor = UIColor.white
        bodyLabel.textAlignment = .left
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "MIST does the work of curating brands who value transparency, so you can clear your conscience, effortlessly.")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
        
        bodyLabel.attributedText = attrString
        self.view.addSubview(bodyLabel)
        return bodyLabel
    }()
    
    internal lazy var body2Label: UILabel = {
        let body2Label = UILabel()
        body2Label.textColor = UIColor.white
        body2Label.textAlignment = .left
        body2Label.lineBreakMode = .byWordWrapping
        body2Label.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "We curate sustainably-made, long-lasting pieces designed by creatives who put quality & our rivers first, so that you can feel good about what you wear.")
        attrString.addAttribute(NSAttributedStringKey.kern, value: 0, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
        
        body2Label.attributedText = attrString
        self.view.addSubview(body2Label)
        return body2Label
    }()
    
    internal lazy var nextPageButton: UIButton = {
        let nextPageButton = UIButton(type: .roundedRect)
        nextPageButton.layer.cornerRadius = 0
        nextPageButton.tintColor = UIColor.white
        nextPageButton.layer.borderColor = UIColor.white.cgColor
        nextPageButton.layer.borderWidth = 1.0
        nextPageButton.titleLabel?.font = UIFont.LatoRegularSmall()
        nextPageButton.setTitle("   Skim our guide on transparency →   ", for: UIControlState())
        self.view.addSubview(nextPageButton)
        
        nextPageButton.addTarget(self, action: #selector(SustainabilityGuideViewController.nextPagePressed), for: .touchUpInside)
        return nextPageButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.DarkBlue()
        setNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        Timer.scheduledTimer(timeInterval: 0, target: self, selector: #selector(SustainabilityGuideViewController.updateLabel(_:)), userInfo: 0, repeats: false)
    }
    
    @objc func updateLabel(_ timer: Timer) {
        
        let array = ["the creatives", "the eco-conscious", "the questioners", "the curious", "you"]
        
        let index = Int((timer.userInfo as AnyObject) as! NSNumber)
        if (index >= array.count) {
            return;
        }
        
        let attrString = NSMutableAttributedString(string: array[index])
        attrString.addAttribute(NSAttributedStringKey.kern, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularMedium(), range: NSMakeRange(0, attrString.length))
        
        updatingHeaderLabel.attributedText = attrString
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SustainabilityGuideViewController.updateLabel), userInfo: index+1, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font:UIFont.LatoBoldMedium(),
            NSAttributedStringKey.foregroundColor:UIColor.black,
            NSAttributedStringKey.kern:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "ABOUT US", attributes: attributes as? [NSAttributedStringKey : Any])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let doneButton = ProductBarButtonItem(title: "Done", actionTarget: self, actionSelector: #selector(SustainabilityGuideViewController.closePressed), buttonColor: UIColor.DoneBlue())
        
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc internal func closePressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextPagePressed() {
        // push sustainability info guide
    }

}
