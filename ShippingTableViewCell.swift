//
//  ShippingTableViewCell.swift
//  Mist
//
//  Created by Robin Mehta on 2/21/16.
//  Copyright © 2016 Bounce Labs. All rights reserved.
//

import UIKit

class ShippingTableViewCell: UITableViewCell {

    internal lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Lato-Bold", size: 15)
        self.contentView.addSubview(titleLabel)
        return titleLabel
    }()
    
    internal lazy var detail: UILabel = {
        let detail = UILabel()
        detail.textColor = UIColor.gray
        detail.textAlignment = .center
        detail.lineBreakMode = .byWordWrapping
        detail.numberOfLines = 0
        detail.font = UIFont(name: "Lato-Regular", size: 15)
        self.contentView.addSubview(detail)
        return detail
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func layoutViews() {

        titleLabel.pinToLeftEdgeOfSuperview(offset: 10)
        titleLabel.centerVerticallyInSuperview()
        
        detail.centerVerticallyInSuperview()
        detail.pinToRightEdgeOfSuperview(offset: 10)
        
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
