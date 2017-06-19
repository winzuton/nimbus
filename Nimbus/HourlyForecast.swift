//
//  HourlyForecast.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/14.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import Foundation

class HourlyForecast {

// Private class variables
    private var _time: Double!
    private var _icon: String!
    private var _temperature: Double!
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
            value = unixConvertedDate.timeOfTheDay()
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
    
    // Sets and returns temperature
    var temperature: Double {
        
        get {
            if _temperature == nil {
                _temperature = 0
            }
            return _temperature
        }
        
        set {
            _temperature = newValue
        }
        
    }

    // Returns temperature string
    var temperatureString: String {
        var value = ""
        
        if _temperature == nil {
            _temperature = 0
        } else {
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            
            let temp = formatter.string(for: _temperature)
            
            value = "\(temp ?? "--")°"
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
        if let temperature = data["temperature"] as? Double {
            _temperature = temperature
        }
        if let precipProbability = data["precipProbability"] as? Double {
            _precipProbability = precipProbability
        }
    }
    
}

extension Date {
    func timeOfTheDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        return formatter.string(from: self) // unixConvertedDate 
    }
}
