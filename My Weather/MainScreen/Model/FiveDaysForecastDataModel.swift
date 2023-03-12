//
//  FiveDaysForecastDataModel.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import UIKit

struct FiveDaysForecastDataModel {
    var day: String
    var iconID: String
    var temperatureMin: Int
    var temperatureMax: Int
    var date: Int64
    
    init(data: [EveryThreeHoursForecastDataModel]) {
        day = {
            return data[0].day
        }()
        temperatureMin = {
            let minTempsArray = data.map { $0.temperatureMin }
            let maxTempsArray = data.map { $0.temperatureMax }
            return (minTempsArray + maxTempsArray).min() ?? 99
        }()
        temperatureMax = {
            let minTempsArray = data.map { $0.temperatureMin }
            let maxTempsArray = data.map { $0.temperatureMax }
            return (minTempsArray + maxTempsArray).max() ?? 99
        }()
        iconID = {
            var string = ""
            data.forEach {
                switch $0.time {
                case "12:00", "13:00", "14:00":
                    string = $0.iconID
                default:
                    return
                }
            }
            return string
        }()
        date = {
            return data[0].date
        }()
     }
}
