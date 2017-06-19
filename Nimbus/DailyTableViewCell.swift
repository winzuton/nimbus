//
//  DailyTableViewCell.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/13.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit

class DailyTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var precipProbability: UILabel!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var lowTemperature: UILabel!
    @IBOutlet weak var highTemperature: UILabel!
    
    func configureCell(forecast: DailyForecast) {
        // TODO: light and dark versions
        icon.image = UIImage(named: "dark-\(forecast.icon)")
        day.text = forecast.timeString
        lowTemperature.text = forecast.lowTemperatureString
        highTemperature.text = forecast.highTemperatureString
        
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
