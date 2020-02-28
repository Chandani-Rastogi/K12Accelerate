//
//  NotificationTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 22/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var widthLayout: NSLayoutConstraint!
    
    @IBOutlet weak var heightLayout: NSLayoutConstraint!
    
   // @IBOutlet weak var detailed: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detailed: UITextView!
    
    @IBOutlet weak var greetingImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
