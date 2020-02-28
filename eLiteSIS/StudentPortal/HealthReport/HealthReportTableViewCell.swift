//
//  HealthReportTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 31/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import Cosmos

class HealthReportTableViewCell: UITableViewCell {

    @IBOutlet weak var healthRating: CosmosView!
    @IBOutlet weak var recom_Label: UILabel!
    @IBOutlet weak var vision_index: UILabel!
    @IBOutlet weak var clean_index: UILabel!
    @IBOutlet weak var behav_index: UILabel!
    @IBOutlet weak var hygiene_index: UILabel!
    @IBOutlet weak var nutri_index: UILabel!
    @IBOutlet weak var smileIndex: UILabel!
    
    @IBOutlet weak var BDM_index: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
