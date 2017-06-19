//
//  Forecast.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/14.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import Foundation

// Singleton class
class Forecast {

    static let sharedInstance = Forecast()
    private init() {}
    
    private let apiKey = "235e2ff428a75aba02852239dfb46754"
    private let apiURL = "https://api.darksky.net/forecast/"
    private var optionals = "?exclude=minutely,alerts,flags&units="
    var units = "si" // default // TODO: since many countried use this, so first bold is c 
    
    var url: String!
    
    func updateURL() {
        url = "\(apiURL)\(apiKey)/\(Location.sharedInstance.latitude!),\(Location.sharedInstance.longitude!)\(optionals)\(units)"
    }
    
}
