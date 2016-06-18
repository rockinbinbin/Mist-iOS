//
//  RoundedRectButton.swift
//  Bounce
//
//  Created by Steven on 7/22/15.
//  Copyright (c) 2015 PluckPhoto. All rights reserved.
//

import UIKit

/**
 * A rounded rect, used in the introduction view screens.
 */
class CustomLoginButton: UIButton {
    
//    let loginFB = UIButton(type: .Custom)
    let img = UIImage(named: "loginFB")
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    init() {
        super.init(frame: CGRectMake(0, 0, 0, 0))

        self.setImage(img, forState: .Normal)
        indicator.alpha = 0.0
        self.addSubview(indicator)
        indicator.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
            }
            else {
                self.backgroundColor = UIColor.clearColor()
            }
        }
    }
}
