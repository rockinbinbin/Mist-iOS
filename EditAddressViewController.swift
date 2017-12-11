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
        nameTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Address Name", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        nameTextField.attributedPlaceholder = attrString
        nameTextField.layer.borderColor = UIColor.black.cgColor
        nameTextField.textAlignment = .left
        nameTextField.returnKeyType = .next
        
        self.view.addSubview(nameTextField)
        
        return nameTextField
    }()
    
    internal lazy var streetTextField: UITextField = {
        let streetTextField = UITextField()
        streetTextField.translatesAutoresizingMaskIntoConstraints = false;
        streetTextField.delegate = self
        streetTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Street Address", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        streetTextField.attributedPlaceholder = attrString
        streetTextField.layer.borderColor = UIColor.black.cgColor
        streetTextField.textAlignment = .left
        streetTextField.returnKeyType = .next
        
        self.view.addSubview(streetTextField)
        
        return streetTextField
    }()
    
    internal lazy var unitTextField: UITextField = {
        let unitTextField = UITextField()
        unitTextField.translatesAutoresizingMaskIntoConstraints = false;
        unitTextField.delegate = self
        unitTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Unit", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        unitTextField.attributedPlaceholder = attrString
        unitTextField.layer.borderColor = UIColor.black.cgColor
        unitTextField.textAlignment = .left
        unitTextField.returnKeyType = .next
        unitTextField.autocorrectionType = .no
        
        self.view.addSubview(unitTextField)
        
        return unitTextField
    }()
    
    internal lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.translatesAutoresizingMaskIntoConstraints = false;
        cityTextField.delegate = self
        cityTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "City", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        cityTextField.attributedPlaceholder = attrString
        cityTextField.layer.borderColor = UIColor.black.cgColor
        cityTextField.textAlignment = .left
        cityTextField.returnKeyType = .next
        
        self.view.addSubview(cityTextField)
        
        return cityTextField
    }()
    
    internal lazy var stateTextField: UITextField = {
        let stateTextField = UITextField()
        stateTextField.translatesAutoresizingMaskIntoConstraints = false;
        stateTextField.delegate = self
        stateTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "State", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        stateTextField.attributedPlaceholder = attrString
        stateTextField.layer.borderColor = UIColor.black.cgColor
        stateTextField.textAlignment = .left
        stateTextField.returnKeyType = .next
        
        self.view.addSubview(stateTextField)
        
        return stateTextField
    }()
    
    internal lazy var zipTextField: UITextField = {
        let zipTextField = UITextField()
        zipTextField.translatesAutoresizingMaskIntoConstraints = false;
        zipTextField.delegate = self
        zipTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Zip", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        zipTextField.attributedPlaceholder = attrString
        zipTextField.layer.borderColor = UIColor.black.cgColor
        zipTextField.textAlignment = .left
        zipTextField.returnKeyType = .next
        
        self.view.addSubview(zipTextField)
        
        return zipTextField
    }()
    
    internal lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false;
        phoneTextField.delegate = self
        phoneTextField.textColor = UIColor.black
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Phone Number", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        phoneTextField.attributedPlaceholder = attrString
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.textAlignment = .left
        phoneTextField.returnKeyType = .next
        
        self.view.addSubview(phoneTextField)
        
        return phoneTextField
    }()
    
    internal lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .roundedRect)
        doneButton.layer.cornerRadius = 0
        doneButton.backgroundColor = UIColor.black
        doneButton.tintColor = UIColor.white
        doneButton.titleLabel!.font = UIFont.LatoRegularSmall()
        doneButton.titleLabel!.textColor = UIColor.white
        
        let attributedString = NSMutableAttributedString(string: "DONE")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "DONE".count))
        doneButton.setAttributedTitle(attributedString, for: UIControlState())
        
        self.view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(EditAddressViewController.donePressed), for: .touchUpInside)
        return doneButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditAddressViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditAddressViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    func keyboardWillShow(_ notification: Notification) {
        if keyboardUp {
            if (nameTextField.isFirstResponder || streetTextField.isFirstResponder) {
                return
            }
            if let info = notification.userInfo {
                //                    let movementHeight = -(info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue().size.height
                UIView.beginAnimations("keyboardGoinUP", context: nil)
                UIView.setAnimationBeginsFromCurrentState(true)
                UIView.setAnimationDuration(0.3)
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (info[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).intValue)!)
                
                if (cityTextField.isFirstResponder || phoneTextField.isFirstResponder) {
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.size.height * 0.15)
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
                UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (info[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).intValue)!)
                
                if (stateTextField.isFirstResponder || zipTextField.isFirstResponder) {
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.size.height * 0.15)
                }
                else if (phoneTextField.isFirstResponder) {
                    self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.size.height * 0.3)
                }
                keyboardUp = true
            } else {
                print("Error: No user info for keyboardWillShow")
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if !keyboardUp {
            return
        }
        
        if let info = notification.userInfo {
            UIView.beginAnimations("keyboardGoinDOWN", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: (info[UIKeyboardAnimationCurveUserInfoKey]! as AnyObject).intValue)!)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            UIView.commitAnimations()
            
            keyboardUp = false
        } else {
            print("Error: No user info for keyboardWillShow")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
            NSFontAttributeName: UIFont.LatoRegularMedium(),
            NSForegroundColorAttributeName:UIColor.black,
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "EDIT ADDRESS", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "blackBackArrow"), for: UIControlState())
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(EditAddressViewController.backPressed), for: .touchUpInside)
        
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
    
    func createAddressString() -> NSString {
        let address = NSMutableString(string: streetTextField.text!)
        address.append(" ")
        address.append(unitTextField.text!)
        address.append(", ")
        address.append(cityTextField.text!)
        address.append(" ")
        address.append(stateTextField.text!)
        address.append(", ")
        address.append(zipTextField.text!)
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
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}
