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
    
    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        tableView.backgroundColor = UIColor.white
        self.view.addSubview(tableView)
        return tableView
    }()
    
    internal lazy var newAddressButton: UIButton = {
        let newAddressButton = UIButton(type: .roundedRect)
        newAddressButton.layer.cornerRadius = 0
        newAddressButton.backgroundColor = UIColor.black
        newAddressButton.tintColor = UIColor.white
        newAddressButton.titleLabel!.font = UIFont.LatoRegularSmall()
        newAddressButton.titleLabel!.textColor = UIColor.white
  
        let attributedString = NSMutableAttributedString(string: "ENTER NEW ADDRESS")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "ENTER NEW ADDRESS".characters.count))
        newAddressButton.setAttributedTitle(attributedString, for: UIControlState())
        
        self.view.addSubview(newAddressButton)
        newAddressButton.addTarget(self, action: #selector(ShippingViewController.newAddressPressed), for: .touchUpInside)
        return newAddressButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ParseManager1.getInstance().loadAddressesDelegate = self
//        ParseManager1.getInstance().loadAddresses()
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.viewWillAppear(animated)
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont.LatoRegularMedium(),
            NSForegroundColorAttributeName:UIColor.black,
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "SHIPPING", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "blackBackArrow"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(ShippingViewController.backPressed), for: .touchUpInside)
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    func newAddressPressed() {
        self.navigationController?.pushViewController(NewAddressViewController(), animated: true)
    }

    // MARK: - Tableview Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = userAddresses?.count {
            return count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "shippingCell"
        var cell: ShippingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? ShippingTableViewCell
        
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
            cell?.selectionStyle = .none
        }
        
//        cell?.titleLabel.text = thisAddress.objectForKey("Name") as! String?
//        cell?.detail.text = thisAddress.objectForKey("Address") as! String?
        
        cell?.titleLabel.text = "Home"
        cell?.detail.text = "306 North State St"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = EditAddressViewController()
//        editVC.currentAddress = userAddresses?[indexPath.row] as? PFObject
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    func didLoadAddresses(_ objects: [AnyObject]!) {
        userAddresses = objects as? NSArray
        tableView.reloadData()
    }

}
