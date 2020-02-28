//
//  StudyProgressCell.swift
//  eLiteSIS
//
//  Created by apar on 14/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class StudyProgressCell: UITableViewCell {

    @IBOutlet weak var showProgress: MBCircularProgressBarView!
    @IBOutlet weak var percentageLabel: UILabel!
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
