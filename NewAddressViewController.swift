//
//  NewAddressViewController.swift
//  Mist
//
//  Created by Robin Mehta on 2/21/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit

extension UITextField {
    
    func useUnderline(_ width: CGFloat, height: CGFloat) {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: height - borderWidth, width: width, height: height)
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

class NewAddressViewController: UIViewController, UITextFieldDelegate {

    convenience init(image: UIImage) {
        self.init()
        mainImage = image
    }
    
    var keyboardUp = false
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.text = "Add Shipping Address"
        titleLabel.font = UIFont.LatoRegularMedium()
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var nameTextField: UITextField = {
        let nameTextField = UITextField()
        nameTextField.translatesAutoresizingMaskIntoConstraints = false;
        nameTextField.delegate = self
        nameTextField.textColor = UIColor.white
        
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
        nameTextField.autocorrectionType = .no
        
        self.view.addSubview(nameTextField)
        
        return nameTextField
    }()
    
    internal lazy var streetTextField: UITextField = {
        let streetTextField = UITextField()
        streetTextField.translatesAutoresizingMaskIntoConstraints = false;
        streetTextField.delegate = self
        streetTextField.textColor = UIColor.white
        
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
        streetTextField.autocorrectionType = .no
        
        self.view.addSubview(streetTextField)
        return streetTextField
    }()
    
    internal lazy var cityTextField: UITextField = {
        let cityTextField = UITextField()
        cityTextField.translatesAutoresizingMaskIntoConstraints = false;
        cityTextField.delegate = self
        cityTextField.textColor = UIColor.white
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName :UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "City", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        cityTextField.attributedPlaceholder = attrString
        cityTextField.layer.borderColor = UIColor.black.cgColor
        cityTextField.textAlignment = .left
        cityTextField.returnKeyType = .next
        cityTextField.autocorrectionType = .no
        
        self.view.addSubview(cityTextField)
        
        return cityTextField
    }()
    
    internal lazy var unitTextField: UITextField = {
        let unitTextField = UITextField()
        unitTextField.translatesAutoresizingMaskIntoConstraints = false;
        unitTextField.delegate = self
        unitTextField.textColor = UIColor.white
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName : UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Apt/Unit", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        unitTextField.attributedPlaceholder = attrString
        unitTextField.layer.borderColor = UIColor.black.cgColor
        unitTextField.textAlignment = .left
        unitTextField.returnKeyType = .next
        unitTextField.autocorrectionType = .no
        
        self.view.addSubview(unitTextField)
        
        return unitTextField
    }()
    
    internal lazy var stateTextField: UITextField = {
        let stateTextField = UITextField()
        stateTextField.translatesAutoresizingMaskIntoConstraints = false;
        stateTextField.delegate = self
        stateTextField.textColor = UIColor.white
        
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
        stateTextField.autocorrectionType = .no
        
        
        self.view.addSubview(stateTextField)
        
        return stateTextField
    }()
    
    internal lazy var zipTextField: UITextField = {
        let zipTextField = UITextField()
        zipTextField.translatesAutoresizingMaskIntoConstraints = false;
        zipTextField.delegate = self
        zipTextField.textColor = UIColor.white
        zipTextField.autocorrectionType = .no
        
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
        zipTextField.keyboardType = .numberPad
        
        self.view.addSubview(zipTextField)
        
        return zipTextField
    }()
    
    internal lazy var phoneTextField: UITextField = {
        let phoneTextField = UITextField()
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false;
        phoneTextField.delegate = self
        phoneTextField.textColor = UIColor.white
        phoneTextField.autocorrectionType = .no
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.gray,
            NSFontAttributeName :UIFont.LatoRegularSmall()
        ]
        
        let attrString = NSMutableAttributedString(string: "Phone Number (optional)", attributes:attributes)
        attrString.addAttribute(NSKernAttributeName, value: 1.5, range: NSMakeRange(0, attrString.length))
        phoneTextField.attributedPlaceholder = attrString
        phoneTextField.layer.borderColor = UIColor.black.cgColor
        phoneTextField.textAlignment = .left
        phoneTextField.returnKeyType = .next
        phoneTextField.keyboardType = .phonePad
        
        self.view.addSubview(phoneTextField)
        
        return phoneTextField
    }()
    
    var mainImage: UIImage? = nil {
        didSet {
            guard let image = mainImage else {
                return
            }
            
            backgroundImageView.image = image
        }
    }
    
    internal lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .roundedRect)
        doneButton.layer.cornerRadius = 0
        doneButton.backgroundColor = UIColor.black
        doneButton.tintColor = UIColor.white
        doneButton.titleLabel!.font = UIFont.LatoRegularSmall()
        doneButton.titleLabel!.textColor = UIColor.white
        
        let attributedString = NSMutableAttributedString(string: "DONE")
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(4), range: NSRange(location: 0, length: "DONE".characters.count))
        doneButton.setAttributedTitle(attributedString, for: UIControlState())
        
        self.view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(NewAddressViewController.donePressed), for: .touchUpInside)
        return doneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        return imageView
    }()
    
    func setupLayout() {
        backgroundImageView.centerHorizontallyInSuperview()
        backgroundImageView.sizeToWidth(self.view.frame.size.width)
        backgroundImageView.sizeToHeight(self.view.frame.size.height)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.makeBlurImage(backgroundImageView)
        
        let widthWithPadding = self.view.frame.size.width - 50
        let heightRatio = self.view.frame.size.height * 0.05
        
        titleLabel.pinToTopEdgeOfSuperview(offset: 50)
        titleLabel.pinToLeftEdgeOfSuperview(offset: 20)
        
        nameTextField.pinToLeftEdgeOfSuperview(offset: 20)
        nameTextField.positionBelowItem(titleLabel, offset: 30)
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewAddressViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewAddressViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewAddressViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            NSFontAttributeName:UIFont.LatoRegularMedium(),
            NSForegroundColorAttributeName:UIColor.black,
            NSKernAttributeName:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "ADD ADDRESS", attributes: attributes as? [String : AnyObject])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        // todo: fix parse loading stuff
//        if let defaultAddress = PFUser.currentUser()?.objectForKey("defaultAddress") {
//            let btnName = UIButton()
//            btnName.setImage(UIImage(named: "blackBackArrow"), forState: .Normal)
//            btnName.frame = CGRectMake(0, 0, 30, 30)
//            btnName.addTarget(self, action: #selector(NewAddressViewController.backPressed), forControlEvents: .TouchUpInside)
//
//            let leftBarButton = UIBarButtonItem()
//            leftBarButton.customView = btnName
//            self.navigationItem.leftBarButtonItem = leftBarButton
//        }
//        else {
//            // TODO: add something to prompt a user to add address before continuing
//            self.navigationItem.hidesBackButton = true
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func backPressed() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func donePressed() {
        
        if (nameTextField.text == "" || streetTextField.text == "" || cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "") {
            let alert = UIAlertView(title: "Double check your address!", message: "Seems like you missed something. Double check your address, so that you can receive your purchases!", delegate: self, cancelButtonTitle: "OK")
            alert.show()
        }
        else {
            
            let address = createAddressString()
            
            // todo: fix parse loading stuff
            
//            ParseManager1.getInstance().addAddressdelegate = self
//            ParseManager1.getInstance().addAddress(nameTextField.text!, withAddress: address as String, withPhone: phoneTextField.text!, withStreet: streetTextField.text!, withUnit: unitTextField.text!, withCity: cityTextField.text!, withState: stateTextField.text!, withZip: zipTextField.text!)
//            
//            if let defaultAddress = PFUser.currentUser()?.objectForKey("defaultAddress") {
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//            else {
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
        }
    }
    
    func didAddAddressWithError(_ error: NSError!) {
        print("SUCCESS")
    }

}
