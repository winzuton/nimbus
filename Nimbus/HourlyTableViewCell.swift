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
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var precipProbability: UILabel!
    
    func configureCell(forecast: HourlyForecast) {
        // TODO: light and dark versions
        icon.image = UIImage(named: "dark-\(forecast.icon)")
        time.text = forecast.timeString
        temperature.text = forecast.temperatureString
        
        // TODO: see for snow and sleet as well
        if (forecast.precipProbability > 0) && (forecast.icon.caseInsensitiveCompare(Weather.rain) == .orderedSame) {
            precipProbability.isHidden = false
            precipProbability.text = forecast.precipProbabilityString
        } else {
            precipProbability.isHidden = true
        }
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
