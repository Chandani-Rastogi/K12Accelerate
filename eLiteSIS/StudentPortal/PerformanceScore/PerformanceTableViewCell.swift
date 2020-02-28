//
//  PerformanceTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class PerformanceTableViewCell: UITableViewCell {

    @IBOutlet weak var grade: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var backview: UIView!
    
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var obtained: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
