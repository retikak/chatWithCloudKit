//
//  CustomTableViewCell.swift
//  ChatWithCloudKit
//
//  Created by Retika Kumar on 8/15/16.
//  Copyright © 2016 kumar.retika. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var user: User?

    @IBOutlet weak var profileImageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageSummaryLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithMessage(message: Message) {
        messageSummaryLabel.text = message.text
        timestampLabel.text = String(message.timestamp)
        nameLabel.text = UserController.sharedController.loggedInUser?.familyName
        
        
        
    }
    
    
}
