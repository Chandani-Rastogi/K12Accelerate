//
//  dashboardTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 04/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class dashboardTableViewCell: UITableViewCell {

    @IBOutlet weak var totalsubjects: UILabel!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var studyPercentage: UILabel!
    
    @IBOutlet weak var presentPercentage: UILabel!
    @IBOutlet weak var presentDays: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var presentProgress: MBCircularProgressBarView!
    @IBOutlet weak var studyProgress: MBCircularProgressBarView!
    @IBOutlet weak var overallObtained: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var overAllPercentage: UILabel!
    @IBOutlet weak var overallProgress: MBCircularProgressBarView!
    
    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
