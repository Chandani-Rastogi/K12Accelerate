//
//  GalleryTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 04/12/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
