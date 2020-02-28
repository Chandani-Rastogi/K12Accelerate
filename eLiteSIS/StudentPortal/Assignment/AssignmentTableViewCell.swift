//
//  AssignmentTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {

    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var issueDateLabel: UILabel!
    @IBOutlet weak var subjectAssignmentLabel: UILabel!
    
    @IBOutlet weak var DownloadButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
