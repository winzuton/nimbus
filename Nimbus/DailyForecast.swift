//
//  DailyForecast.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/14.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import Foundation

class DailyForecast {
    
    // Private class variables
    private var _time: Double!
    private var _icon: String!
    private var _lowTemperature: Double!
    private var _highTemperature: Double!
    private var _precipProbability: Double!
    
    // Getter functions
    
    // Sets and returns UNIX time stamp of the day
    var time: Double {
        
        get {
            return _time
        }
        
        set{
            _time = newValue
        }
        
    }
    
    // Returns day string
    var timeString: String {
        var value = ""
        if _time != nil {
            // Convert UNIX time stamp to standard Gregorian Calendar date
            let unixConvertedDate = Date(timeIntervalSince1970: _time)
            value = unixConvertedDate.dayOfTheWeek()
        }
        
        return value
    }
    
    // Sets and returns icon name
    var icon: String {
        
        get {
            if _icon == nil {
                _icon = ""
            }
            return _icon
        }
        
        set {
            _icon = newValue
        }
        
    }
    
    // Sets and returns low temperature
    var lowTemperature: Double {
        
        get {
            if _lowTemperature == nil {
                _lowTemperature = 0
            }
            return _lowTemperature
        }
        
        set {
            _lowTemperature = newValue
        }
        
    }
    
    // Returns low temperature string
    var lowTemperatureString: String {
        var value = ""
        
        if _lowTemperature == nil {
            _lowTemperature = 0
        } else {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let temp = formatter.string(for: _lowTemperature)
            
            value = "⇣\(temp ?? "--")°"
        }
        
        return value
    }
    
    // Sets and returns high temperature
    var highTemperature: Double {
        
        get {
            if _highTemperature == nil {
                _highTemperature = 0
            }
            return _highTemperature
        }
        
        set {
            _highTemperature = newValue
        }
        
    }
    
    // Returns high temperature string
    var highTemperatureString: String {
        var value = ""
        
        if _highTemperature == nil {
            _highTemperature = 0
        } else {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let temp = formatter.string(for: _highTemperature)
            
            value = "⇡\(temp ?? "--")°"
        }
        
        return value
    }
    
    // Sets and returns precipitation probability
    var precipProbability: Double {
        
        get {
            if _precipProbability == nil {
                _precipProbability = 0
            }
            return _precipProbability
        }
        
        set {
            _precipProbability = newValue
        }
        
    }
    
    // Returns precipitation probability string
    var precipProbabilityString: String {
        var value = ""
        
        if _precipProbability == nil {
            _precipProbability = 0
        } else {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let prob = formatter.string(for: (_precipProbability * 100))
            
            value = "\(prob ?? "--")%"
        }
        
        return value
    }
    
    init(data: Dictionary<String, Any>) {
        if let time = data["time"] as? Double {
            _time = time
        }
        if let icon = data["icon"] as? String {
            _icon = icon
        }
        if let lowTemperature = data["temperatureMin"] as? Double {
            _lowTemperature = lowTemperature
        }
        if let highTemperature = data["temperatureMax"] as? Double {
            _highTemperature = highTemperature
        }
        if let precipProbability = data["precipProbability"] as? Double {
            _precipProbability = precipProbability
        }
    }
    
}

extension Date {
    func dayOfTheWeek() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self) // unixConvertedDate
    }
}
