//
//  TeacherTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var title1: UILabel!
    
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var emailaddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
