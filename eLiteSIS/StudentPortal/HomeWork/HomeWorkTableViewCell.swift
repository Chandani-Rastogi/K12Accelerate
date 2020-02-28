//
//  HomeWorkTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 07/11/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class HomeWorkTableViewCell: UITableViewCell {

    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var assignmentLabel: UILabel!
    @IBOutlet weak var homeworkDesciprtion: UITextView!
    @IBOutlet weak var fileimage: UIImageView!
    
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var viewinfoButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
