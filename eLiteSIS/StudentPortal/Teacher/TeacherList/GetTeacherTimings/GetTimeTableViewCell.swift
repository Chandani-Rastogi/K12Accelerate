//
//  GetTimeTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 03/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class GetTimeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var Monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var wedneday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    
    @IBOutlet weak var friday: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
