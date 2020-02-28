//
//  ProfileTableViewCell.swift
//  eLiteSIS
//
//  Created by apar on 31/07/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var motherName: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var fatherName: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var classID: UILabel!
    @IBOutlet weak var classSession: UILabel!
    @IBOutlet weak var dateApplied: UILabel!
    @IBOutlet weak var Address: UILabel!
    @IBOutlet weak var state: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var addressType: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var streetnumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
