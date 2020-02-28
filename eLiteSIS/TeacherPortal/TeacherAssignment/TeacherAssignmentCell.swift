//
//  TeacherAssignmentCell.swift
//  eLiteSIS
//
//  Created by apar on 31/10/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class TeacherAssignmentCell: UITableViewCell {

      @IBOutlet weak var profileImageView: UIImageView!
       @IBOutlet weak var datetext: UILabel!
       @IBOutlet weak var nameText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
