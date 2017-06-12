//
//  HourlyTableViewCell.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/12.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var lowTemperature: UILabel!
    @IBOutlet weak var highTemperature: UILabel!
    @IBOutlet weak var precipitationRate: UILabel!
    
    func configureCell() { // TODO: Create 'Forecast' class for parameter
        icon.image = UIImage(named: "icon-dark")
        time.text = "12:00 AM"
        lowTemperature.text = "⇣24°"
        highTemperature.text = "⇡29°"
        precipitationRate.text = "30%"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
