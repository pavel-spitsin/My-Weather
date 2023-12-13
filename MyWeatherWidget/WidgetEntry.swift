//
//  WidgetEntry.swift
//  My Weather
//
//  Created by Pavel
//

import SwiftUI
import WidgetKit

struct WidgetEntry: TimelineEntry {
    var date: Date
    var cityName: String
    var currentTemperature: String
    var weatherIcon: Image
    var weatherDescription: String
}
