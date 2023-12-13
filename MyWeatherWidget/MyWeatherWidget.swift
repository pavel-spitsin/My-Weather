//
//  MyWeatherWidget.swift
//  MyWeatherWidget
//
//  Created by Pavel
//

import WidgetKit
import SwiftUI

struct MyWeatherWidget: Widget {
    let kind: String = "MyWeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WidgetProvider()) { entry in
            if #available(iOS 17.0, *) {
                WidgetEntryView(entry: entry)
                    .widgetBackground(Color.blue)
            } else {
                WidgetEntryView(entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
            }
        }
        .configurationDisplayName("MyWeather")
        .description("Current weather data based on your current location")
        .supportedFamilies([.systemSmall])
    }
}
