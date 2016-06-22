//
//  editAddressViewController.swift
//  Mist
//
//  Created by Robin Mehta on 2/21/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit
//import Parse

class EditAddressViewController: UIViewController, UITextFieldDelegate {
    
    var keyboardUp = false
    
    //var currentAddress : PFObject?
    var currentAddress : String?
    
    internal lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false;
        nameTextField.delegate = self
        nameTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "Address Name", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        nameTextField.attributedPlaceholder = attrString
        nameTextField.layer.borderColor = UIColor.blackColor().CGColor
        nameTextField.textAlignment = .Left
        nameTextField.returnKeyType = .Next
        
        self.view.addSubview(nameTextField)
        
        return nameTextField
    }()
    
    internal lazy var streetTextField: UITextField = {
        let streetTextField = UITextField()
        streetTextField.translatesAutoresizingMaskIntoConstraints = false;
        streetTextField.delegate = self
        streetTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "Street Address", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        streetTextField.attributedPlaceholder = attrString
        streetTextField.layer.borderColor = UIColor.blackColor().CGColor
        streetTextField.textAlignment = .Left
        streetTextField.returnKeyType = .Next
        
        self.view.addSubview(streetTextField)
        
        return streetTextField
    }()
    
    internal lazy var unitTextField: UITextField = {
        let unitTextField = UITextField()
        unitTextField.translatesAutoresizingMaskIntoConstraints = false;
        unitTextField.delegate = self
        unitTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "Unit", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        unitTextField.attributedPlaceholder = attrString
        unitTextField.layer.borderColor = UIColor.blackColor().CGColor
        unitTextField.textAlignment = .Left
        unitTextField.returnKeyType = .Next
        unitTextField.autocorrectionType = .No
        
        self.view.addSubview(unitTextField)
        
        return unitTextField
    }()
    
    internal lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.translatesAutoresizingMaskIntoConstraints = false;
        cityTextField.delegate = self
        cityTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "City", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        cityTextField.attributedPlaceholder = attrString
        cityTextField.layer.borderColor = UIColor.blackColor().CGColor
        cityTextField.textAlignment = .Left
        cityTextField.returnKeyType = .Next
        
        self.view.addSubview(cityTextField)
        
        return cityTextField
    }()
    
    internal lazy var stateTextField: UITextField = {
        let stateTextField = UITextField()
        stateTextField.translatesAutoresizingMaskIntoConstraints = false;
        stateTextField.delegate = self
        stateTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "State", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        stateTextField.attributedPlaceholder = attrString
        stateTextField.layer.borderColor = UIColor.blackColor().CGColor
        stateTextField.textAlignment = .Left
        stateTextField.returnKeyType = .Next
        
        self.view.addSubview(stateTextField)
        
        return stateTextField
    }()
    
    internal lazy var zipTextField: UITextField = {
        let zipTextField = UITextField()
        zipTextField.translatesAutoresizingMaskIntoConstraints = false;
        zipTextField.delegate = self
        zipTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "Zip", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        zipTextField.attributedPlaceholder = attrString
        zipTextField.layer.borderColor = UIColor.blackColor().CGColor
        zipTextField.textAlignment = .Left
        zipTextField.returnKeyType = .Next
        
        self.view.addSubview(zipTextField)
        
        return zipTextField
    }()
    
    internal lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false;
        phoneTextField.delegate = self
        phoneTextField.textColor = UIColor.blackColor()
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.grayColor(),
            NSFontAttributeName : UIFont(name: "Lato-Light", size: 14)!
        ]
        
        let attrString = NSMutableAttributedString(string: "Phone Number", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        phoneTextField.attributedPlaceholder = attrString
        phoneTextField.layer.borderColor = UIColor.blackColor().CGColor
        phoneTextField.textAlignment = .Left
        phoneTextField.returnKeyType = .Next
        
        self.view.addSubview(phoneTextField)
        
        return phoneTextField
    }()
    
    internal lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .RoundedRect)
        doneButton.layer.cornerRadius = 0
        doneButton.backgroundColor = UIColor.blackColor()
        doneButton.tintColor = UIColor.whiteColor()
        doneButton.titleLabel!.font = UIFont(name: "Lato-Light", size: 14.0)
        doneButton.titleLabel!.textColor = UIColor.whiteColor()
        
        let attributedString = NSMutableAttributedString(string: "DONE")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "DONE".characters.count))
        doneButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        
        self.view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(EditAddressViewController.donePressed), forControlEvents: .TouchUpInside)
        return doneButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let widthWithPadding = self.view.frame.size.width - 50
        let heightRatio = self.view.frame.size.height * 0.05
        
        nameTextField.pinToLeftEdgeOfSuperview(offset: 20)
        nameTextField.pinToTopEdgeOfSuperview(offset: self.view.frame.size.height * 0.2)
        nameTextField.sizeToWidth(widthWithPadding)
        nameTextField.sizeToHeight(heightRatio)
        
        streetTextField.positionBelowItem(nameTextField, offset: 20)
        streetTextField.pinToLeftEdgeOfSuperview(offset: 20)
        streetTextField.sizeToWidth(widthWithPadding)
        streetTextField.sizeToHeight(heightRatio)
        
        unitTextField.positionBelowItem(streetTextField, offset: 20)
        unitTextField.pinToLeftEdgeOfSuperview(offset: 20)
        unitTextField.sizeToWidth(widthWithPadding/4)
        unitTextField.sizeToHeight(heightRatio)
        
        cityTextField.positionBelowItem(streetTextField, offset: 20)
        cityTextField.positionToTheRightOfItem(unitTextField, offset: 20)
        cityTextField.sizeToWidth((widthWithPadding - 20) * 0.75)
        cityTextField.sizeToHeight(heightRatio)
        
        stateTextField.pinToLeftEdgeOfSuperview(offset: 20)
        stateTextField.positionBelowItem(unitTextField, offset: 20)
        stateTextField.sizeToWidth(widthWithPadding/4)
        stateTextField.sizeToHeight(heightRatio)
        
        zipTextField.positionToTheRightOfItem(stateTextField, offset: 20)
        zipTextField.positionBelowItem(unitTextField, offset: 20)
        zipTextField.sizeToWidth(widthWithPadding/4)
        zipTextField.sizeToHeight(heightRatio)
        
        phoneTextField.positionBelowItem(stateTextField, offset: 20)
        phoneTextField.pinToLeftEdgeOfSuperview(offset: 20)
        phoneTextField.sizeToHeight(heightRatio)
        phoneTextField.sizeToWidth(widthWithPadding)
        
        doneButton.positionBelowItem(phoneTextField, offset: 30)
        doneButton.centerHorizontallyInSuperview()
        doneButton.sizeToHeight(heightRatio * 2)
        doneButton.sizeToWidth(widthWithPadding)
        
        nameTextField.useUnderline(widthWithPadding, height: heightRatio)
        streetTextField.useUnderline(widthWithPadding, height: heightRatio)
        unitTextField.useUnderline(widthWithPadding/4, height: heightRatio)
        cityTextField.useUnderline((widthWithPadding - 20) * 0.75, height: heightRatio)
        stateTextField.useUnderline(widthWithPadding / 4, height: heightRatio)
        zipTextField.useUnderline(widthWithPadding / 4, height: heightRatio)
        phoneTextField.useUnderline(widthWithPadding, height: heightRatio)
        
        setNavBar()
        
        // Dismisses the keyboard if the user taps outside of the keyboard region.
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditAddressViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditAddressViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditAddressViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // fetch all addresses
        
        
        setTextFields()
    }
    
    func setTextFields() {
//        nameTextField.text = currentAddress?.valueForKey("Name") as? String
//        streetTextField.text = currentAddress?.valueForKey("Street") as? String
//        cityTextField.text = currentAddress?.valueForKey("City") as? String
//        stateTextField.text = currentAddress?.valueForKey("State") as? String
//        zipTextField.text = currentAddress?.valueForKey("Zip") as? String
//        phoneTextField.text = currentAddress?.valueForKey("Phone") as? String
        
        nameTextField.text = "Mission Control"
        streetTextField.text = "Mission St"
        cityTextField.text = "San Francisco"
        stateTextField.text = "California"
        zipTextField.text = "48104"
        phoneTextField.text = "5164773055"
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardUp {
            if (nameTextField.isFirstResponder() || streetTextField.isFirstResponder()) {
                return
            }
            if let info = notification.userInfo {
                //                    let movementHeight = -(info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
                UIView.beginAnimations("keyboardGoinUP", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(0.3)
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!)
                
                if (cityTextField.isFirstResponder() || phoneTextField.isFirstResponder()) {
                    self.view.frame = CGRectOffset(self.view.frame, 0, -self.view.frame.size.height * 0.15)
                }
            }
            return
        }
        else {
            if let info = notification.userInfo {
                //            let movementHeight = -(info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
                UIView.beginAnimations("keyboardGoinUP", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(0.3)
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!)
                
                if (stateTextField.isFirstResponder() || zipTextField.isFirstResponder()) {
                    self.view.frame = CGRectOffset(self.view.frame, 0, -self.view.frame.size.height * 0.15)
                }
                else if (phoneTextField.isFirstResponder()) {
                    self.view.frame = CGRectOffset(self.view.frame, 0, -self.view.frame.size.height * 0.3)
                }
                keyboardUp = true
            } else {
                print("Error: No user info for keyboardWillShow")
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if !keyboardUp {
            return
        }
        
        if let info = notification.userInfo {
            UIView.beginAnimations("keyboardGoinDOWN", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: info[UIKeyboardAnimationCurveUserInfoKey]!.integerValue)!)
            self.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            UIView.commitAnimations()
            
            keyboardUp = false
        } else {
            print("Error: No user info for keyboardWillShow")
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == nameTextField) {
            streetTextField.becomeFirstResponder()
        }
        else if (textField == streetTextField) {
            unitTextField.becomeFirstResponder()
        }
        else if (textField == unitTextField) {
            cityTextField.becomeFirstResponder()
        }
        else if (textField == cityTextField) {
            stateTextField.becomeFirstResponder()
        }
        else if (textField == stateTextField) {
            zipTextField.becomeFirstResponder()
        }
        else if (textField == zipTextField) {
            phoneTextField.becomeFirstResponder()
        }
        else {
            phoneTextField.endEditing(true)
        }
        return true
    }

    
    func setNavBar() {
        let titleLabel = UILabel()
        let attributes: NSDictionary = [
            NSFontAttributeName:UIFont(name: "Lato-Regular", size: 16)!,
            NSForegroundColorAttributeName:UIColor.blackColor(),
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "EDIT ADDRESS", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "blackBackArrow"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(EditAddressViewController.backPressed), forControlEvents: .TouchUpInside)
        
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
    
    func createAddressString() -> NSString {
        let address = NSMutableString(string: streetTextField.text!)
        address.appendString(" ")
        address.appendString(unitTextField.text!)
        address.appendString(", ")
        address.appendString(cityTextField.text!)
        address.appendString(" ")
        address.appendString(stateTextField.text!)
        address.appendString(", ")
        address.appendString(zipTextField.text!)
        return address
    }
    
    func donePressed() {
        
        if (nameTextField.text == "" || streetTextField.text == "" || cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "") {
            let alert = UIAlertView(title: "Double check your address!", message: "Seems like you missed something. Double check your address, so that you can receive your purchases!", delegate: self, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        else {
            let address = createAddressString()
            
//            currentAddress?.setValue(nameTextField.text, forKey: "Name")
//            currentAddress?.setValue(streetTextField.text, forKey: "Street")
//            currentAddress?.setValue(cityTextField.text, forKey: "City")
//            currentAddress?.setValue(stateTextField.text, forKey: "State")
//            currentAddress?.setValue(zipTextField.text, forKey: "Zip")
//            currentAddress?.setValue(phoneTextField.text, forKey: "Phone")
//            currentAddress?.setValue(address, forKey: "Address")
//            
//            currentAddress?.saveInBackground()
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}
