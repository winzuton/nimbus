//
//  CurrentForecast.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/14.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class CurrentForecast {
    
// Private class variables
    private var _location: String!
    private var _time: Double!
    private var _icon: String!
    private var _temperature: Double!
    private var _summary: String!
    private var _precipProbability: Double!
    
    private var _hourlySummary: String!
    private var _dailySummary: String!
    
// Hourly and Daily Forecast classes
    var hourlyForecasts = [HourlyForecast]()
    var dailyForecasts = [DailyForecast]()
    
// For reverse geocoding
    lazy var geocoder = CLGeocoder()
    
// Getter functions
    
    var location: String {
        if _location == nil {
            _location = ""
        }
        return _location
    }
    
    // TODO: to be used when calculating current time and the actual time 
    // var rawTime: Double {}
    
    // Sets and returns UNIX time stamp of the day
    var time: Double {
        
        get {
            return _time
        }
        
        set{
            _time = newValue
        }
        
    }
    
    // Display NOW in the UI instead of the real time
    var timeString: String {
        if _time == nil {
            _time = 0
        }
        return Label.now
    }
    
    var icon: String {
        if _icon == nil {
            _icon = Weather.blank
        }
        return _icon
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
    
    // TODO: See if number is rounded
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
    
    var summary: String {
        if _summary == nil {
            _summary = ""
        }
        return _summary
    }
    
    var currentSummary: String {
        var newSummary = summary
        // Include precipitaton probability in summary if icon is rain // TODO: see if snow and sleet will also appear in precipType?
        if _icon.caseInsensitiveCompare(Weather.rain) == .orderedSame && !newSummary.isEmpty {
            newSummary = "\(summary) (\(precipProbabilityString))"
        }
        return newSummary
    }
    
    var hourlySummary: String {
        if _hourlySummary == nil {
            _hourlySummary = ""
        }
        return _hourlySummary
    }
    
    var dailySummary: String {
        if _dailySummary == nil {
            _dailySummary = ""
        }
        return _dailySummary
    }
    
// Download forecast data and assign data to hourly and daily as well
    // NOTE: Airplane and Wifi can be on at the same time.. so focus on if can connect only or not 
    // TODO: Delegate when internet connection is established
    // TODO: Read closures and typealiases 
    func downloadData(completed: @escaping DownloadComplete) {
        if let forecastURL = URL(string: Forecast.sharedInstance.url) {
            
            // TODO: What if cannot connect in Alamofire
            // Show spinner on status bar
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            //TODO: Display message when cannot establish any connection or the query limit exceeded 
            
            // Request data from Dark Sky API
            Alamofire.request(forecastURL).responseJSON { response in
                if let result = response.value as? Dictionary<String, Any> {
                    
                    // NOTE: Still have data when internet connection is off
                        // RESEARCH: where is this saved
                        // Do I need to have NSUSerDefaults or whatever still be implemented?
                    // print("*Still cached?")
                    
                    // Currently
                    if let currently = result["currently"] as? Dictionary<String, Any> {
                        if let time = currently["time"] as? Double {
                            self._time = time
                        }
                        if let icon = currently["icon"] as? String {
                            self._icon = icon
                        }
                        if let temperature = currently["temperature"] as? Double {
                            self._temperature = temperature
                        }
                        if let summary = currently["summary"] as? String {
                            self._summary = summary
                        }
                        if let precipProbability = currently["precipProbability"] as? Double {
                            self._precipProbability = precipProbability
                        }
                    }
                    
                    // Hourly
                    if let hourly = result["hourly"] as? Dictionary<String, Any> {
                        if let summary = hourly["summary"] as? String {
                            self._hourlySummary = summary
                        }
                        if let forecasts = hourly["data"] as? [Dictionary<String, Any>] {
                            
                            // clear hourly forecasts if there are new data
                            self.hourlyForecasts.removeAll()
                            for obj in forecasts {
                                let forecast = HourlyForecast(data: obj)
                                self.hourlyForecasts.append(forecast)
                            }
                            // Remove current time
                            self.hourlyForecasts.remove(at: 0)
                        }
                    }
                    
                    // Daily
                    if let daily = result["daily"] as? Dictionary<String, Any> {
                        if let summary = daily["summary"] as? String {
                            self._dailySummary = summary
                        }
                        if let forecasts = daily["data"] as? [Dictionary<String, Any>] {
                            
                            // clear daily forecasts if there are new data 
                            self.dailyForecasts.removeAll()
                            for obj in forecasts {
                                let forecast = DailyForecast(data: obj)
                                self.dailyForecasts.append(forecast)
                            }
                            // Remove current day
                            self.dailyForecasts.remove(at: 0)
                        }
                    }

                    // Geocode Location
                    self.geocoder.reverseGeocodeLocation(Location.sharedInstance.location) { (placemarks, error) in
                        
                        
                        // Process Response
                        self.processReverseGeocoding(withPlacemarks: placemarks, error: error)
                        
                        // End
                        completed() // TODO: Research
                    }
                } else {
                    // No response value
                    // End
                    completed() // TODO: Research
                }
            }
            
        } else {
            // TODO: No URL message
            // End
            completed() // TODO: Research
        }
    }
    
    private func processReverseGeocoding(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))") // TODO: Print in Status view?
            self._location = ""
            // TODO: Access cached location from previous call and set here when no internet connection
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                self._location = placemark.subLocality
                print("Sublocality name: \(self._location)")
                // TODO: Set current location to NSUserDefaults or something like that
            } else {
                self._location = ""
                print("No matching address found.") // TODO: Print in Status view?
            }
        }
    }
    
// TODO: function to convert temperature units (use private vars) 
    
// TODO: function to calculate current vs actual time to refresh data from cache etc
    
}
