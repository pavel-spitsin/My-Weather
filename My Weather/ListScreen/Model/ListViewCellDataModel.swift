//
//  ListViewCellDataModel.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

struct ListViewCellDataModel {
    var cityName: String
    var weatherDescription: String
    var temperatureCurrent: Int
    var temperatureMin: Int
    var temperatureMax: Int
    
    init(data: [String : AnyObject]) {
        cityName = {
            guard let name = data["name"] as? String else { return "-" }
            return name
        }()
        weatherDescription = {
            guard let weather = data["weather"] as? [AnyObject] else { return "-" }
            guard let description = weather[0]["description"] as? String else { return "-" }
            return description.capitalizingFirstLetter()
        }()
        temperatureCurrent = {
            guard let tempCurrent = data["main"]?["temp"] as? Double else { return 99 }
            return Int(tempCurrent)
        }()
        temperatureMin = {
            guard let tempMin = data["main"]?["temp_min"] as? Double else { return 99 }
            return Int(tempMin)
        }()
        temperatureMax = {
            guard let tempMax = data["main"]?["temp_max"] as? Double else { return 99 }
            return Int(tempMax)
        }()
     }
}
