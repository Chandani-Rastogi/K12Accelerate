//
//  NotificationSummaryCell.swift
//  eLiteSIS
//
//  Created by Apar256 on 24/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class NotificationSummaryCell: UITableViewCell {

    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
