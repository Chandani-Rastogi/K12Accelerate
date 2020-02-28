//
//  FacultyProfileCell.swift
//  eLiteSIS
//
//  Created by apar on 26/09/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class FacultyProfileCell: UITableViewCell {

    @IBOutlet weak var postalCodeText: UILabel!
    @IBOutlet weak var countryText: UILabel!
    @IBOutlet weak var statText: UILabel!
    @IBOutlet weak var cityTExt: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var cgpaTExt: UILabel!
    @IBOutlet weak var yearOfPassingtext: UILabel!
    @IBOutlet weak var qualifactionText: UILabel!
    @IBOutlet weak var emailIDText: UILabel!
    @IBOutlet weak var mobileText: UILabel!
    @IBOutlet weak var genderText: UILabel!
    @IBOutlet weak var categoryText: UILabel!
    @IBOutlet weak var mothersNAmeTExt: UILabel!
    @IBOutlet weak var fathersNameText: UILabel!
    @IBOutlet weak var dobText: UILabel!
    @IBOutlet weak var addressLine: UILabel!
    @IBOutlet weak var streetNAMe: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
