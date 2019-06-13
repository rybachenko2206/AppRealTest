//
//  PersonTableViewCell.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell, ReusableCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.avatarImageView.layer.cornerRadius = 8
        self.avatarImageView.layer.masksToBounds = true
        
    }
    
    static func height() -> CGFloat {
        return 83
    }
    
}
