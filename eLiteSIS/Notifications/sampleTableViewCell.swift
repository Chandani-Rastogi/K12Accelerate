//
//  sampleTableViewCell.swift
//  eLiteSIS
//
//  Created by Apar256 on 24/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class sampleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detailed: UITextView!
    
    @IBOutlet weak var greetingImageView: UIImageView!
    @IBOutlet weak var detailTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
