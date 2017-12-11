//
//  PaymentInformationViewController.swift
//  Mist
//
//  Created by Steven on 8/4/16.
//
//

import UIKit

/**
 A superclass for the shipping address and credit card entry view controllers.
 */
class PaymentInformationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Init
    
    /**
     The preferred method for initialization - a factory pattern method which generates and configures
     an enclosing UINavigationController.
     */
    class func createWithNavigationController(_ backgroundImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: PaymentInformationViewController(backgroundImage: backgroundImage))
        
        navigationController.navigationBar.barTintColor = UIColor(white: 0.44, alpha: 1.0)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        
        return navigationController
    }
    
    convenience init(backgroundImage: UIImage) {
        self.init()
        
        backgroundImageView.image = backgroundImage
        
        let doneButton = ProductBarButtonItem(title: "Cancel", actionTarget: self, actionSelector: #selector(cancelPressed), buttonColor: UIColor.white)
        navigationItem.leftBarButtonItem = doneButton
        
        view.setNeedsUpdateConstraints()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: - UI Components
    
    fileprivate lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = UIApplication.shared.keyWindow!.frame
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.addSubview(blurEffectView)
        
        self.view.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.text = "Add Shipping Address"
        label.font = UIFont.LatoRegularMedium()
        
        self.view.addSubview(label)
        return label
    }()
    
    class TextField: UITextField {
        convenience init(placeholder: String) {
            self.init()
            
            translatesAutoresizingMaskIntoConstraints = false
            textColor = .white
            
            let attributes = [
                NSAttributedStringKey.foregroundColor: UIColor.gray,
                NSAttributedStringKey.font : UIFont.LatoBoldSmall()
            ]
            
            font = UIFont.LatoRegularSmall()
            
            let attrString = NSMutableAttributedString(string: placeholder.uppercased(), attributes:attributes)
            attrString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSMakeRange(0, attrString.length))
            attributedPlaceholder = attrString
            layer.borderColor = UIColor.black.cgColor
            textAlignment = .left
            returnKeyType = .next
            autocorrectionType = .no
        }
    }
    
    fileprivate lazy var nameTextField: UITextField = {
        let textField = TextField(placeholder: "Full name")
        textField.delegate = self
        textField.autocapitalizationType = .words
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var addressLine1TextField: UITextField = {
        let textField = TextField(placeholder: "Address line 1 (street address)")
        textField.delegate = self
        textField.autocapitalizationType = .words
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var addressLine2TextField: UITextField = {
        let textField = TextField(placeholder: "Address line 2 (apt., suite, unit)")
        textField.delegate = self
        textField.autocapitalizationType = .words
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var cityTextField: UITextField = {
        let textField = TextField(placeholder: "City")
        textField.delegate = self
        textField.autocapitalizationType = .words
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var stateTextField: UITextField = {
        let textField = TextField(placeholder: "State")
        textField.delegate = self
        textField.autocapitalizationType = .allCharacters
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var unitTextField: UITextField = {
        let textField = TextField(placeholder: "Unit")
        textField.delegate = self
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var zipTextField: UITextField = {
        let textField = TextField(placeholder: "ZIP")
        textField.delegate = self
        textField.keyboardType = .numberPad
        self.view.addSubview(textField)
        return textField
    }()
    
    fileprivate lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .roundedRect)
        doneButton.layer.cornerRadius = 0
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.2).cgColor
        doneButton.backgroundColor = UIColor.black
        doneButton.tintColor = UIColor.white
        doneButton.titleLabel!.font = UIFont.LatoRegularSmall()
        doneButton.titleLabel!.textColor = UIColor.white
        
        let attributedString = NSMutableAttributedString(string: "DONE")
        attributedString.addAttribute(NSAttributedStringKey.kern, value: CGFloat(4), range: NSRange(location: 0, length: "DONE".count))
        doneButton.setAttributedTitle(attributedString, for: UIControlState())
        
        self.view.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        return doneButton
    }()
    
    // MARK: - Layout
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        backgroundImageView.pinToEdgesOfSuperview()
        
        titleLabel.pinToLeftEdgeOfSuperview(offset: 20)
        titleLabel.pinToTopEdgeOfSuperview(offset: 40)
        
        nameTextField.pinToLeftEdgeOfSuperview(offset: 20)
        nameTextField.pinToRightEdgeOfSuperview(offset: 20)
        nameTextField.positionBelowItem(titleLabel, offset: 40)
        
        addressLine1TextField.pinToLeftEdgeOfSuperview(offset: 20)
        addressLine1TextField.pinToRightEdgeOfSuperview(offset: 20)
        addressLine1TextField.positionBelowItem(nameTextField, offset: 40)
        
        addressLine2TextField.pinToLeftEdgeOfSuperview(offset: 20)
        addressLine2TextField.pinToRightEdgeOfSuperview(offset: 20)
        addressLine2TextField.positionBelowItem(addressLine1TextField, offset: 40)
        
        cityTextField.pinToLeftEdgeOfSuperview(offset: 20)
        cityTextField.sizeToWidth(self.view.frame.size.width - 160)
        cityTextField.positionBelowItem(addressLine2TextField, offset: 40)
        
        stateTextField.pinToRightEdgeOfSuperview(offset: 20)
        stateTextField.sizeToWidth(100)
        stateTextField.positionBelowItem(addressLine2TextField, offset: 40)
        
        zipTextField.pinToRightEdgeOfSuperview(offset: 20)
        zipTextField.sizeToWidth(100)
        zipTextField.positionBelowItem(cityTextField, offset: 40)
        
        doneButton.positionBelowItem(zipTextField, offset: 50)
        doneButton.sizeToHeight(50)
        doneButton.pinToSideEdgesOfSuperview(offset: 20)
    }
    
    override func viewDidLayoutSubviews() {
        for field in view.subviews.filter({$0 is UITextField}) {
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = UIColor(white: 1.0, alpha: 0.30).cgColor
            border.frame = CGRect(x: 0, y: field.frame.size.height - width + 5, width: field.frame.size.width, height: width)
            
            border.borderWidth = width
            field.layer.addSublayer(border)
            field.layer.masksToBounds = false
        }
    }
    
    // MARK: - Navigation
    
    @objc internal func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc internal func donePressed() {
        
        let requiredFields = [nameTextField, addressLine1TextField, cityTextField, stateTextField, zipTextField]
        
        for field in requiredFields {
            guard let text = field.text, text != "" else {
                displayError("One of the required text fields was empty. Please enter name, address, city, state, and ZIP.")
                return
            }
        }
        
        guard let stateText = stateTextField.text, let state = USState(abbreviation: stateText) else {
            displayError("The state was invalid. Please enter the abbriviation of a US state.")
            return
        }
        
        let address = MailingAddress(name: nameTextField.text!, street: addressLine1TextField.text!, street2: addressLine2TextField.text, unit: nil, city: cityTextField.text!, state: state, zip: zipTextField.text!)
        
        guard address.isValid else {
            displayError("The zip code was invalid. Please try again!")
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Invalid address.", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: false, completion: nil)
    }
    
    // MARK: - Status Bar
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == zipTextField {
            textField.returnKeyType = .done
        } else {
            textField.returnKeyType = .next
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let textFields = [nameTextField, addressLine1TextField, addressLine2TextField, cityTextField, stateTextField, unitTextField, zipTextField]
        
        if textField == textFields.last! {
            textField.resignFirstResponder()
        } else {
            let nextTextField = textFields[textFields.index(of: textField)! + 1]
            
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        
        return true
    }
}
