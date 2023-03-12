//
//  DateService.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

struct DateService {
    
    //MARK: - Properties
    
    private let dateFormatter = DateFormatter()
    
    //MARK: - Actions
    
    public func convertDoubleToTimeString(doubleDate: Double) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(Int(doubleDate)))
        return dateFormatter.string(from: date)
    }
    
    public func convertInt64ToDayString(int64: Int64, timeShift: Int) -> String {
        dateFormatter.dateFormat = "EEEE"
        let timeZone = TimeZone(secondsFromGMT: timeShift)
        dateFormatter.timeZone = timeZone
        let date = Date(timeIntervalSince1970: TimeInterval(Int(int64)))
        return dateFormatter.string(from: date)
    }
    
    public func convertInt64ToTimeString(int64: Int64, timeShift: Int) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let timeZone = TimeZone(secondsFromGMT: timeShift)
        dateFormatter.timeZone = timeZone
        let date = Date(timeIntervalSince1970: TimeInterval(Int(int64)))
        return dateFormatter.string(from: date)
    }
    
    public func today() -> String {
        dateFormatter.dateFormat = "EEEE"
        let date = Date.now
        return dateFormatter.string(from: date)
    }
}
