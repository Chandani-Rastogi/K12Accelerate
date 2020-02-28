//
//  RecentChatCell.swift
//  eLiteSIS
//
//  Created by apar on 07/01/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class RecentChatCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sendername: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
