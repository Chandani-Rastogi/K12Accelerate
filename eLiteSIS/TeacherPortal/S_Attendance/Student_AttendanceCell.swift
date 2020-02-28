//
//  Student_AttendanceCell.swift
//  eLiteSIS
//
//  Created by apar on 19/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DLRadioButton

class Student_AttendanceCell: UITableViewCell {

    @IBOutlet weak var leavebutton: DLRadioButton!
    @IBOutlet weak var absentbutton: DLRadioButton!
    @IBOutlet weak var presentButton: DLRadioButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var studentName: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
