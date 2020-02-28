//
//  TeacherDashboardTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class TeacherDashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var subject2Percentage: UILabel!
    @IBOutlet weak var subject1percentage: UILabel!
    @IBOutlet weak var subjectProgressBar2: MBCircularProgressBarView!
    @IBOutlet weak var subjectProgressBar1: MBCircularProgressBarView!
    
    @IBOutlet weak var subjectProgressBar3: MBCircularProgressBarView!
    
    @IBOutlet weak var subject3percentage: UILabel!
    
    @IBOutlet weak var subjectLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
