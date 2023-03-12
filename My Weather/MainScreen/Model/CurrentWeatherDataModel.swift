//
//  CurrentWeatherDataModel.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

struct CurrentWeatherDataModel {
    var cityName: String
    var weatherDescription: String
    var currentTemperature: String
    var cloudiness: String
    var humidity: String
    var pressure: String
    var maxTemperature: String
    var minTemperature: String
    var sunrise: String
    var sunset: String
    var windDirection: String
    var windSpeed: String
    var visibility: String
    var iconID: String
    
    init(data: [String : AnyObject]) {
        cityName = {
           return data["name"] as? String ?? "-"
        }()
        weatherDescription = {
            guard let weather = data["weather"] as? [AnyObject] else { return "-" }
            guard let description = weather[0]["description"] as? String else { return "-" }
            return description.capitalizingFirstLetter()
        }()
        currentTemperature = {
            guard let temp = data["main"]?["temp"] as? Double else { return "-" }
            return String(Int(temp))
        }()
        cloudiness = {
            guard let clouds = data["clouds"]?["all"] as? Double else { return "-" }
            return String(Int(clouds))
        }()
        humidity = {
            guard let humidity = data["main"]?["humidity"] as? Double else { return "-" }
            return String(Int(humidity))
        }()
        pressure = {
            guard let pressure = data["main"]?["pressure"] as? Double else { return "-" }
            return String(Int(ValueCalculator().calculateMMHG(from: pressure)))
        }()
        maxTemperature = {
            guard let maxTemp = data["main"]?["temp_max"] as? Double else { return "-" }
            return String(Int(maxTemp))
        }()
        minTemperature = {
            guard let minTemp = data["main"]?["temp_min"] as? Double else { return "-" }
            return String(Int(minTemp))
        }()
        sunrise = {
            guard let doubleDate = data["sys"]?["sunrise"] as? Double else { return "-" }
            return DateService().convertDoubleToTimeString(doubleDate: doubleDate)
        }()
        sunset = {
            guard let doubleDate = data["sys"]?["sunset"] as? Double else { return "-" }
            return DateService().convertDoubleToTimeString(doubleDate: doubleDate)
        }()
        windDirection = {
            guard let direction = data["wind"]?["deg"] as? Double else { return "-" }
            return ValueCalculator().calculateWindDirection(degrees: direction)
        }()
        windSpeed = {
            guard let speed = data["wind"]?["speed"] as? Double else { return "-" }
            return String(Int(speed))
        }()
        visibility = {
            guard let visibility = data["visibility"] as? Double else { return "-" }
            return String(Int(visibility))
        }()
        iconID = {
            guard let weather = data["weather"] as? [AnyObject] else { return "-" }
            guard let imageID = weather[0]["icon"] as? String else { return "-" }
            return imageID
        }()
    }
    
    func returnData(for parameter: WeatherParameter) -> String {
        switch parameter {
        case .cloudiness:
            return cloudiness
        case .humidity:
            return humidity
        case .pressure:
            return pressure
        case .maxTemperature:
            return maxTemperature
        case .minTemperature:
            return minTemperature
        case .sunrise:
            return sunrise
        case .sunset:
            return sunset
        case .windDirection:
            return windDirection
        case .windSpeed:
            return windSpeed
        case .visibility:
            return visibility
        }
    }
}
