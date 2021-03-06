//
//  SignInViewController.swift
//  Mist
//
//  Created by Robin Mehta on 3/20/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import PureLayout

class SignInViewController: UIViewController, UITextFieldDelegate {

    fileprivate lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor(red: 0.047, green: 0.569, blue: 0.773, alpha: 1.0)
        titleLabel.text = "DressPass"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.LatoBoldMedium()
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    fileprivate lazy var logoimageView: UIImageView = {
        let logoimageView = UIImageView(image: UIImage(named: "MLogo"))
        self.view.addSubview(logoimageView)
        return logoimageView
    }()
    
    fileprivate lazy var signUpLabel: UILabel = {
        let signUpLabel = UILabel()
        signUpLabel.textColor = UIColor.white
        let attrString = NSMutableAttributedString(string: "LOG IN")
        attrString.styleText("LOG IN")
        signUpLabel.attributedText = attrString
        signUpLabel.textAlignment = .center
        self.view.addSubview(signUpLabel)
        return signUpLabel
    }()
    
    internal lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.delegate = self
        emailTextField.styleEmailField("Email")

        emailTextField.setLeftPaddingPoints(10)
        emailTextField.setRightPaddingPoints(10)
        self.view.addSubview(emailTextField)
        return emailTextField
    }()
    
    internal lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.delegate = self
        passwordTextField.stylePasswordField("Password")

        passwordTextField.setLeftPaddingPoints(10)
        passwordTextField.setRightPaddingPoints(10)
        self.view.addSubview(passwordTextField)
        return passwordTextField
    }()
    
    fileprivate lazy var alreadyHaveAccountLabel: UILabel = {
        let alreadyHaveAccountLabel = UILabel()
        alreadyHaveAccountLabel.textColor = UIColor.white
        let attrString = NSMutableAttributedString(string: "DON'T HAVE AN ACCOUNT?")
        attrString.styleText("DON'T HAVE AN ACCOUNT?")
        alreadyHaveAccountLabel.attributedText = attrString
        alreadyHaveAccountLabel.textAlignment = .center
        //self.view.addSubview(alreadyHaveAccountLabel)
        return alreadyHaveAccountLabel
    }()
    
    internal lazy var loginButton: UIButton = {
        let loginButton = UIButton(type: .roundedRect)
        loginButton.tintColor = UIColor.white
        let attrString = NSMutableAttributedString(string: "SIGN UP")
        attrString.styleText("SIGN UP")
        loginButton.setAttributedTitle(attrString, for: UIControlState())
        //self.view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(SignUpViewController.loginPressed), for: .touchUpInside)
        
        return loginButton
    }()
    
    
    internal lazy var loginFB: UIButton = {
        //        let loginFB = UIButton(type: .Custom)

//        let loginFB = CustomLoginButton()
        //        let img = UIImage(named: "loginFB")
        //        loginFB.setImage(img, forState: .Normal)
        
        loginFB.addTarget(self, action: #selector(SignInViewController.FBLoginPressed(_:)), for: .touchUpInside)
        self.view.addSubview(loginFB)
        
        
        return loginFB
    }()
    
    internal lazy var letsGo: UIButton = {
        let letsGo = UIButton(type: .roundedRect)
        letsGo.layer.cornerRadius = 0
        //        letsGo.backgroundColor = UIColor(red: 0.047, green: 0.569, blue: 0.773, alpha: 1.0)
        letsGo.layer.borderWidth = 0
        //letsGo.layer.borderColor = UIColor.blueColor().CGColor
        letsGo.tintColor = UIColor.black
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        let attrString = NSMutableAttributedString(string: "SIGN IN")
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.kern, value: 1.5, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.font, value: UIFont.LatoRegularSmall(), range: NSMakeRange(0, attrString.length))
        letsGo.setAttributedTitle(attrString, for: UIControlState())
        
        letsGo.titleLabel?.font = UIFont.LatoRegularMedium()
        
        self.view.addSubview(letsGo)
        
        letsGo.addTarget(self, action: #selector(SignInViewController.letsGoPressed), for: .touchUpInside)
        
        return letsGo
    }()
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setBackgroundGradient()
        self.navigationController?.isNavigationBarHidden = false
        setNavBar()

        logoimageView.autoPinEdge(toSuperviewEdge: .top, withInset: self.view.frame.size.height * 0.2)
        logoimageView.autoAlignAxis(toSuperviewAxis: .vertical)
        emailTextField.autoAlignAxis(toSuperviewAxis: .vertical)

        emailTextField.positionBelowItem(logoimageView, offset: 20)
        emailTextField.autoSetDimensions(to: CGSize(width: self.view.frame.size.width - 80, height: self.view.frame.size.height * 0.08))
        passwordTextField.autoAlignAxis(toSuperviewAxis: .vertical)
        passwordTextField.autoSetDimensions(to: CGSize(width: self.view.frame.size.width - 80, height: self.view.frame.size.height * 0.08))
        passwordTextField.positionBelowItem(emailTextField, offset: 20)

        self.view.addSubview(alreadyHaveAccountLabel)
        self.view.addSubview(loginButton)

        alreadyHaveAccountLabel.positionBelowItem(passwordTextField, offset: 17)
        alreadyHaveAccountLabel.centerHorizontallyToItem(passwordTextField, offset: (-self.view.frame.size.width * 0.065))
        
        loginButton.positionToTheRightOfItem(alreadyHaveAccountLabel, offset: 5)
        loginButton.positionBelowItem(passwordTextField, offset: 10)
        
        loginFB.positionBelowItem(alreadyHaveAccountLabel, offset: self.view.frame.size.height * 0.1)

        loginFB.autoAlignAxis(toSuperviewAxis: .vertical)
        loginFB.autoSetDimensions(to: CGSize(width: self.view.frame.size.width - 100, height: self.view.frame.size.height * 0.08))

        letsGo.autoPinEdge(toSuperviewEdge: .bottom)
        letsGo.autoAlignAxis(toSuperviewAxis: .vertical)
        letsGo.autoSetDimensions(to: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 0.15))
    }

    func setBackgroundGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.createPlumGradient()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.layer.addSublayer(gradientLayer)
    }
    
    func setNavBar() {
        let titleLabel = UILabel()
        
        let attributes: NSDictionary = [
            NSAttributedStringKey.font:UIFont.LatoRegularMedium(),
            NSAttributedStringKey.foregroundColor:UIColor.black,
            NSAttributedStringKey.kern:CGFloat(3.69)
        ]
        
        let attributedTitle = NSAttributedString(string: "SIGN IN", attributes: attributes as? [NSAttributedStringKey : Any])
        
        titleLabel.attributedText = attributedTitle
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        let doneButton = ProductBarButtonItem(title: "Back", actionTarget: self, actionSelector: #selector(SignInViewController.closePressed), buttonColor: UIColor.DoneBlue())
        
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == emailTextField) {
            passwordTextField.becomeFirstResponder()
        }
        else if (textField == passwordTextField) {
            passwordTextField.endEditing(true)
        }
        return true
    }
    
    
    override internal func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func letsGoPressed() {
//        let username = self.emailTextField.text
//        let password = self.passwordTextField.text
//        
//        // Validate the text fields
//        if (username?.characters.count) < 5 {
//            let alert = UIAlertView(title: "Oops!", message: "Username must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            return
//        }
//        if (password?.characters.count) < 5 {
//            let alert = UIAlertView(title: "Oops!", message: "Password must be greater than 5 characters", delegate: self, cancelButtonTitle: "OK")
//            alert.show()
//            return
//        }
//        else {
//            let spinner: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
//            spinner.startAnimating()
//            
//            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user, error) -> Void in
//                
//                spinner.stopAnimating()
//                
//                if ((user) != nil) {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        if (user?.valueForKey("City") != nil) {
//                            self.navigationController?.pushViewController(AccountViewController(), animated: true)
//                        }
//                        else {
//                            self.navigationController?.pushViewController(AccountViewController(), animated: true)
//                        }
//                    })
//                    
//                } else {
//                    let alert = UIAlertView(title: "Please check your username and password!", message: "If you don't already have an account, be sure to sign up instead.", delegate: self, cancelButtonTitle: "OK")
//                    alert.show()
//                }
//            })
//        }
    }
    
    // MARK: - Login Handlers
    
    func handleLoginFailed(_ error: NSError, sender: CustomLoginButton!) {
        print("Login failed with error \(error)")
        
        UIView.animate(withDuration: 0.25, animations: {
            sender.indicator.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.25, delay: 0.25, options: UIViewAnimationOptions.curveEaseIn, animations: {
            sender.titleLabel?.alpha = 1.0
            }, completion: nil)
        
        
        // TODO: MAKE LOGIN LOADING INDICATOR GO AWAY.
        loginFB.isEnabled = true
        
        let alertController = UIAlertController(
            title: "Uh oh! Login failed.",
            message: "In Facebook > Settings > Apps, make sure that “Apps, Websites, and Plugins” is enabled.",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let continueAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(continueAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /**
     * Stores user ID and full name in Parse.
     *
     * - parameter user: The new PFUser signing up.
     */
//    func handleNewUser(user: PFUser?) {
//
////        var fbRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
////        fbRequest.startWithCompletionHandler({ (FBSDKGraphRequestConnection, result, error) -> Void in
////            
////            if (error == nil && result != nil) {
////                let facebookData = result as! NSDictionary //FACEBOOK DATA IN DICTIONARY
////                let id = (facebookData.objectForKey("id") as? String)
////                let name = (facebookData.objectForKey("name") as? String)
////                let gender = (facebookData.objectForKey("gender") as? String)
////                let email = (facebookData.objectForKey("email") as? String)
////                
////                if let id = id {
////                    PFUser.currentUser()?.setObject(id, forKey: "facebookId")
////                }
////                
////                if let name = name {
////                    PFUser.currentUser()?.setObject(name, forKey: "fullName")
////                }
////                
////                if let gender = gender {
////                    PFUser.currentUser()?.setObject(gender, forKey: "gender")
////                }
////                if let email = email {
////                    PFUser.currentUser()?.setObject(email, forKey: "email")
////                }
////                user!.saveInBackground()
////            }
////        })
//        
////        FBRequestConnection.startForMeWithCompletionHandler({ (connection: FBRequestConnection!, result: AnyObject?, error: NSError!) -> Void in
////            
////            // Maps from the /me response value names to stored Parse value names.
////            let keyMap = [
////                "id":     ["facebookId"],
////                "name":   ["fullname", "username"],
////                "gender": ["Gender"],
////                "email": ["emailCopy"]
////            ]
////            
////            if error != nil {
////                print(error)
////            }
////            else {
////                for (graphAPIResponseKey, parseKeys) in keyMap {
////                    for parseKey in parseKeys {
////                        if let graphAPIResponseValue = result?.objectForKey(graphAPIResponseKey) as? String {
////                            PFUser.currentUser()?.setObject(graphAPIResponseValue, forKey: parseKey)
////                            user!.saveInBackgroundWithBlock(nil)
////                            
////                            if graphAPIResponseKey == "id" {
////                                let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
////                                dispatch_async(dispatch_get_global_queue(priority, 0)) {
////                                    //self.loadProfilePictureOnMainThread(graphAPIResponseValue)
////                                }
////                            }
////                        }
////                    }
////                }
////            }
////        })
//
//        self.navigationController?.pushViewController(AccountViewController(), animated: true)
//    }
    
//    func handleReturningUser(user: PFUser?, setupComplete: Bool) {
//        // User has entered the app and completed setup
//        
//        if (user?.valueForKey("City") != nil) {
//            self.navigationController?.pushViewController(AccountViewController(), animated: true)
//        }
//        else {
//            self.navigationController?.pushViewController(AccountViewController(), animated: true)
//        }
//    }
    
    @objc func FBLoginPressed(_ sender: CustomLoginButton!) {

        // TODO: FIX
//        let login = FBSDKLoginManager()
//        login.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self) { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
//            if ((error) != nil) {
//                // handle error
//            }
//            else if (result.isCancelled) {
//                // handle user-cancelled login
//            }
//            else {
//                // handle logged in
//                self.navigationController?.pushViewController(NewAddressViewController(), animated: true)
//            }
//        }
    }
    
    func loginPressed() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    
    @objc internal func closePressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
