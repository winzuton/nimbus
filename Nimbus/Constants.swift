//
//  Constants.swift
//  Nimbus
//
//  Created by Winston Tabar on 2017/06/14.
//  Copyright © 2017年 Winston Tabar. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()

struct Unit {
    static let kelvinConstant = 273.15
}

struct Weather {
    static let blank = "blank" // default, circle icon
    static let clearDay = "clear-day"
    static let clearNight = "clear-night"
    static let rain = "rain"
    static let snow = "snow"
    static let sleet = "sleet"
    static let wind = "wind"
    static let fog = "fog"
    static let cloudy = "cloudy"
    static let partlyCloudyDay = "partly-cloudy-day"
    static let partlyCloudyNight = "partly-cloudy-night"
}

struct UISize {
    static let hourlyHeaderView = 220
    static let dailyHeaderView = 20
    static let updateView = 20
}

struct Label {
    static let now = "Now"
}

