//
//  TeacherListTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 02/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TeacherListTableViewCell: UITableViewCell {

    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var timings: UILabel!
    @IBOutlet weak var subjectName: UILabel!
    @IBOutlet weak var teacherName: UILabel!
    
    @IBOutlet weak var viewTimings: UIButton!
    @IBOutlet weak var teacherProfileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
