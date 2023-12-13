//
//  WidgetWeatherIcons.swift
//  My Weather
//
//  Created by Pavel
//

import SwiftUI

enum WidgetWeatherIcons: String {
    //Day
    case clearSkyDay = "01d"
    case fewCloudsDay = "02d"
    case scatteredCloudsDay = "03d"
    case brokenCloudsDay = "04d"
    case showerRainDay = "09d"
    case rainDay = "10d"
    case thunderstormDay = "11d"
    case snowDay = "13d"
    case mistDay = "50d"
    
    //Night
    case clearSkyNight = "01n"
    case fewCloudsNight = "02n"
    case scatteredCloudsNight = "03n"
    case brokenCloudsNight = "04n"
    case showerRainNight = "09n"
    case rainNight = "10n"
    case thunderstormNight = "11n"
    case snowNight = "13n"
    case mistNight = "50n"
    
    var systemWeatherIcon: Image {
        switch self {
        case .clearSkyDay:
            return Image(systemName: "sun.max.fill")
        case .fewCloudsDay:
            return Image(systemName: "cloud.sun.fill")
        case .scatteredCloudsDay:
            return Image(systemName: "cloud.fill")
        case .brokenCloudsDay:
            return Image(systemName: "cloud.fill")
        case .showerRainDay:
            return Image(systemName: "cloud.heavyrain.fill")
        case .rainDay:
            return Image(systemName: "cloud.sun.rain.fill")
        case .thunderstormDay:
            return Image(systemName: "cloud.sun.bolt.fill")
        case .snowDay:
            return Image(systemName: "snowflake")
        case .mistDay:
            return Image(systemName: "sun.haze.fill")
        case .clearSkyNight:
            return Image(systemName: "moon.fill")
        case .fewCloudsNight:
            return Image(systemName: "cloud.moon.fill")
        case .scatteredCloudsNight:
            return Image(systemName: "cloud.fill")
        case .brokenCloudsNight:
            return Image(systemName: "cloud.fill")
        case .showerRainNight:
            return Image(systemName: "cloud.heavyrain.fill")
        case .rainNight:
            return Image(systemName: "cloud.moon.rain.fill")
        case .thunderstormNight:
            return Image(systemName: "cloud.moon.bolt.fill")
        case .snowNight:
            return Image(systemName: "snowflake")
        case .mistNight:
            return Image(systemName: "moon.haze.fill")
        }
    }
}
