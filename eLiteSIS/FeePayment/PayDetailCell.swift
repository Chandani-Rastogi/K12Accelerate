//
//  PayDetailCell.swift
//  eLiteSIS
//
//  Created by Apar256 on 26/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class PayDetailCell: UITableViewCell {
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var itemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
