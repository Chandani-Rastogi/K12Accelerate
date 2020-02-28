//
//  BasicPayTableViewCell.swift
//  eLiteSIS
//
//  Created by Apar256 on 26/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class BasicPayTableViewCell: UITableViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var monthDue: UILabel!
    @IBOutlet weak var paidAmt: UILabel!
    @IBOutlet weak var balance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
