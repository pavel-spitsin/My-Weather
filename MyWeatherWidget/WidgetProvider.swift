//
//  WidgetProvider.swift
//  My Weather
//
//  Created by Pavel
//

import SwiftUI
import WidgetKit
import CoreLocation

struct WidgetProvider: TimelineProvider {
    
    var widgetLocationManager = WidgetLocationManager()
    
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: .now,
                     cityName: "Moscow",
                     currentTemperature: "20",
                     weatherIcon: WidgetWeatherIcons.brokenCloudsDay.systemWeatherIcon,
                     weatherDescription: "Cloudy")
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: .now,
                                 cityName: "Moscow",
                                 currentTemperature: "20",
                                 weatherIcon: WidgetWeatherIcons.brokenCloudsDay.systemWeatherIcon,
                                 weatherDescription: "Cloudy")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> Void) {
        widgetLocationManager.fetchLocation(handler: { location in
            RequestService().requestCurrentWeatherByLocation(location: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { data in
                guard let data else { return }
                let weatherData = CurrentWeatherDataModel(data: data)
                
                let entry = WidgetEntry(date: .now,
                                         cityName: weatherData.cityName,
                                         currentTemperature: weatherData.currentTemperature,
                                         weatherIcon: WidgetWeatherIcons(rawValue: weatherData.iconID)?.systemWeatherIcon ?? Image(systemName: "questionmark.circle.fill"),
                                         weatherDescription: weatherData.weatherDescription)
                
                let nextUpdate = Calendar.current.date(
                    byAdding: DateComponents(minute: 15),
                    to: Date()
                )!
                
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(nextUpdate)
                )
                
                completion(timeline)
            }
        })
    }
}
