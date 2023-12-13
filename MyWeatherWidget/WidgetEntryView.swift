//
//  WidgetEntryView.swift
//  My Weather
//
//  Created by Pavel
//

import SwiftUI
import WidgetKit

struct WidgetEntryView: View {
    var entry: WidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.cityName)
                    .lineLimit(1)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(.white)
            }

            Text("\(entry.currentTemperature)" + "°")
                .lineLimit(1)
                .font(.system(size: 50))
                .foregroundStyle(.white)

            entry.weatherIcon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)

            Text(entry.weatherDescription)
                .lineLimit(1)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
        }
    }
}

//MARK: - Preview

struct WidgetViewPreviews: PreviewProvider {
    static var previews: some View {
        WidgetEntryView(entry: WidgetEntry(date: .now,
                                                     cityName: "Moscow",
                                                     currentTemperature: "-20",
                                                     weatherIcon: Image(systemName: "cloud.fill"),
                                                     weatherDescription: "Scattered clouds"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .widgetBackground(Color.blue)
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
