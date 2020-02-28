//
//  EventTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 19/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startDate: UILabel!
    
    @IBOutlet weak var desc: UILabel!
  
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var heading: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
