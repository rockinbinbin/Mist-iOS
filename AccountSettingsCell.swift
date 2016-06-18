//
//  AccountSettingsCell.swift
//  Mist
//
//  Created by Robin Mehta on 2/20/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit

class AccountSettingsCell: UITableViewCell {
    
    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.textAlignment = .Center
        titleLabel.lineBreakMode = .ByWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Lato-Regular", size: 15)
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var detail: UILabel = {
        let detail = UILabel()
        detail.textColor = UIColor.grayColor()
        detail.textAlignment = .Center
        detail.lineBreakMode = .ByWordWrapping
        detail.numberOfLines = 0
        detail.font = UIFont(name: "Lato-Regular", size: 15)
        self.contentView.addSubview(detail)
        return detail
    }()
    
    let imgView = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutViews() {
        self.contentView.addSubview(imgView)

        imgView.pinToLeftEdgeOfSuperview(offset: 10)
        imgView.centerVerticallyInSuperview()
        
        titleLabel.positionToTheRightOfItem(imgView, offset: 10)
        titleLabel.centerVerticallyInSuperview()
        
        detail.centerVerticallyInSuperview()
        detail.pinToRightEdgeOfSuperview(offset: 10)
        
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
