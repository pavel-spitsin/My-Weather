//
//  ValueCalculator.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

struct ValueCalculator {
    public func calculateWindDirection(degrees: Double) -> String {
        switch degrees {
        case 0...23:
            return "N"
        case 24...68:
            return "NE"
        case 69...113:
            return "E"
        case 114...158:
            return "SE"
        case 159...203:
            return "S"
        case 204...248:
            return "SW"
        case 249...293:
            return "W"
        case 294...336:
            return "NW"
        case 337...360:
            return "N"
        default:
            return "-"
        }
    }
    
    public func calculateMMHG(from hPA: Double) -> Double {
        return hPA/1.333
    }
}
