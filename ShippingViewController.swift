//
//  ShippingViewController.swift
//  Mist
//
//  Created by Robin Mehta on 2/21/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit
//import Parse

class ShippingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var userAddresses : NSArray?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = false
        tableView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var newAddressButton: UIButton = {
        let newAddressButton = UIButton(type: .RoundedRect)
        newAddressButton.layer.cornerRadius = 0
        newAddressButton.backgroundColor = UIColor.blackColor()
        newAddressButton.tintColor = UIColor.whiteColor()
        newAddressButton.titleLabel!.font = UIFont(name: "Lato-Light", size: 14.0)
        newAddressButton.titleLabel!.textColor = UIColor.whiteColor()
  
        let attributedString = NSMutableAttributedString(string: "ENTER NEW ADDRESS")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "ENTER NEW ADDRESS".characters.count))
        newAddressButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        self.view.addSubview(newAddressButton)
        newAddressButton.addTarget(self, action: #selector(ShippingViewController.newAddressPressed), forControlEvents: .TouchUpInside)
        return newAddressButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        tableView.pinToTopEdgeOfSuperview(offset: 50)
        tableView.pinToLeftEdgeOfSuperview()
        tableView.pinToRightEdgeOfSuperview()
        tableView.sizeToHeight(400) // change this to num addresses * cell height
        
        newAddressButton.positionBelowItem(tableView, offset: 10)
        newAddressButton.sizeToHeight(50)
        newAddressButton.sizeToWidth(300)
        newAddressButton.centerHorizontallyInSuperview()
        
        self.navigationController?.delegate = self
        
        setNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        ParseManager1.getInstance().loadAddressesDelegate = self
//        ParseManager1.getInstance().loadAddresses()
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        self.viewWillAppear(animated)
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Regular", size: 16)!,
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "SHIPPING", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "blackBackArrow"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(ShippingViewController.backPressed), forControlEvents: .TouchUpInside)
        
        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = rightBarButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func newAddressPressed() {
        self.navigationController?.pushViewController(NewAddressViewController(), animated: true)
    }

    // MARK: - Tableview Datasource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = userAddresses?.count {
            return count
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "shippingCell"
        var cell: ShippingTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? ShippingTableViewCell
        
        //cell?.layoutSubviews()
        
        //let thisAddress : PFObject
        
//        if let address = userAddresses?[indexPath.row] {
//            thisAddress = address as! PFObject
//        }
//        else {
//            thisAddress = PFObject() // to shush compiler
//        }
        
        
        if cell == nil {
            cell = ShippingTableViewCell()
            cell?.selectionStyle = .None
        }
        
//        cell?.titleLabel.text = thisAddress.objectForKey("Name") as! String?
//        cell?.detail.text = thisAddress.objectForKey("Address") as! String?
        
        cell?.titleLabel.text = "Home"
        cell?.detail.text = "306 North State St"
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editVC = EditAddressViewController()
//        editVC.currentAddress = userAddresses?[indexPath.row] as? PFObject
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func didLoadAddresses(objects: [AnyObject]!) {
        userAddresses = objects
        tableView.reloadData()
    }

}
