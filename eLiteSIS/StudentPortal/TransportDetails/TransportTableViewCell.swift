//
//  TransportTableViewCell.swift
//  eLiteSIS
//
//  Created by Apar256 on 20/02/20.
//  Copyright © 2020 apar. All rights reserved.
//

import UIKit

class TransportTableViewCell: UITableViewCell {

    @IBOutlet weak var vehicleNumberLabel: UILabel!
    @IBOutlet weak var dropTimeLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var stopNameLabel: UILabel!
    @IBOutlet weak var routeNoLabel: UILabel!
    @IBOutlet weak var CoMobileNoLabel: UILabel!
    @IBOutlet weak var coordinatorNameLabel: UILabel!
    @IBOutlet weak var CoImageView: UIImageView!
    @IBOutlet weak var driverImageView: UIImageView!
    @IBOutlet weak var driverNumberLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var helperImageView: UIImageView!
    @IBOutlet weak var helperNoLabel: UILabel!
    @IBOutlet weak var helperNameLabel: UILabel!
    @IBOutlet weak var routeTableview: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
