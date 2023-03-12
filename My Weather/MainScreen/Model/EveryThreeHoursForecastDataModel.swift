//
//  EveryThreeHoursForecastDataModel.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

struct EveryThreeHoursForecastDataModel {
    var day: String
    var time: String
    var temperatureCurrent: Int
    var temperatureMin: Int
    var temperatureMax: Int
    var iconID: String
    var date: Int64
    
    init(data: [String : AnyObject], timeShift: Int64) {
        day = {
            guard let currentDate = data["dt"] as? Int64 else { return "-" }
            return DateService().convertInt64ToDayString(int64: currentDate, timeShift: Int(timeShift))
        }()
        time = {
            guard let currentTime = data["dt"] as? Int64 else { return "-" }
            return DateService().convertInt64ToTimeString(int64: currentTime, timeShift: Int(timeShift))
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
        iconID = {
            guard let weatherArray = data["weather"] as? [AnyObject] else { return "-" }
            guard let imageID = weatherArray[0]["icon"] as? String else { return "-" }
            return imageID
        }()
        date = {
           return data["dt"] as? Int64 ?? 0
        }()
     }
}
