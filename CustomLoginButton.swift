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
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        self.setImage(img, for: UIControlState())
        indicator.alpha = 0.0
        self.addSubview(indicator)
        indicator.centerInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var isHighlighted: Bool {
        didSet {
            if (isHighlighted) {
                self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
            }
            else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
}
