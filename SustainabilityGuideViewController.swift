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
        headerLabel.textColor = UIColor.grayColor()
        headerLabel.textAlignment = .Left
        headerLabel.lineBreakMode = .ByWordWrapping
        headerLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: "you are")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
        
        headerLabel.attributedText = attrString
        headerLabel.font = UIFont(name: "Lato-Regular", size: 15)
        self.view.addSubview(headerLabel)
        return headerLabel
    }()
    
    internal lazy var updatingHeaderLabel: UILabel = {
        let updatingHeaderLabel = UILabel()
        updatingHeaderLabel.textColor = UIColor.grayColor()
        updatingHeaderLabel.textAlignment = .Left
        updatingHeaderLabel.lineBreakMode = .ByWordWrapping
        updatingHeaderLabel.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: " beautiful")
        attrString.addAttribute(NSKernAttributeName, value: 2, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value: UIFont(name: "Lato-Regular", size: 13)!, range: NSMakeRange(0, attrString.length))
        
        updatingHeaderLabel.attributedText = attrString
        updatingHeaderLabel.font = UIFont(name: "Lato-Regular", size: 15)
        self.view.addSubview(updatingHeaderLabel)
        return updatingHeaderLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        setNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func layoutViews() {
        headerLabel.pinToTopEdgeOfSuperview(offset: 100)
        headerLabel.pinToLeftEdgeOfSuperview(offset: 30)
        updatingHeaderLabel.positionToTheRightOfItem(headerLabel, offset: 5)
        updatingHeaderLabel.pinToTopEdgeOfSuperview(offset: 100)
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

}
