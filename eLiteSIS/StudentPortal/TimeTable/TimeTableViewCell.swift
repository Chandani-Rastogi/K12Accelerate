//
//  TimeTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 16/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var timeBackView: UIView!
    @IBOutlet weak var classText: UILabel!
  
    @IBOutlet weak var notificationButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        timeBackView.layer.cornerRadius = timeBackView.bounds.height / 2
        timeBackView.layer.masksToBounds = true
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
