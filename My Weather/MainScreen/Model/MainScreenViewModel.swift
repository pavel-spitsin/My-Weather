//
//  MainScreenViewModel.swift
//  My Weather
//
//  Created by Pavel
//

import Combine
import Foundation
import UIKit

final class MainScreenViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var city: String
    //Subscribe in view
    @Published var currentWeatherData: CurrentWeatherDataModel?
    @Published var everyThreeHoursForecastData: [EveryThreeHoursForecastDataModel]?
    @Published var fiveDaysForecastData: [FiveDaysForecastDataModel]?
    
    private var cancelBag = Set<AnyCancellable>()
    
    //MARK: - Init
    
    init(city: String) {
        self.city = city
        setupBindings()
    }
    
    //MARK: - Bindings
    
    private func setupBindings() {
        $city
            .removeDuplicates()
            .receive(on: DispatchQueue.global())
            .sink {
                if $0 == "My location" {
                    LocationService.shared.locationRequest()
                    self.subscribeToLocationService()
                } else {
                    RequestService().requestCurrentWeatherByCityName(name: $0) {
                        guard let data = $0 else { return }
                        self.prepareCurrentWeatherData(data: data)
                    }
                    
                    RequestService().requestFiveDaysForecastByCityName(name: $0) {
                        guard let data = $0 else { return }
                        self.prepareEveryThreeHoursForecastData(data: data)
                    }
                }
            }
            .store(in: &cancelBag)
    }
    
    private func subscribeToLocationService() {
        LocationService.shared.$currentLocation
            .receive(on: DispatchQueue.global())
            .sink {
                guard let location = $0 else { return }
                RequestService().requestCurrentWeatherByLocation(location: location) {
                    guard let data = $0 else { return }
                    self.prepareCurrentWeatherData(data: data)
                }
                RequestService().requestFiveDaysForecastByLocation(location: location) {
                    guard let data = $0 else { return }
                    self.prepareEveryThreeHoursForecastData(data: data)
                }
            }
            .store(in: &cancelBag)
    }
    
    //MARK: - Actions
    
    private func prepareCurrentWeatherData(data: [String : AnyObject]) {
        currentWeatherData = CurrentWeatherDataModel(data: data)
    }
    
    private func prepareEveryThreeHoursForecastData(data: [String : AnyObject]) {
        guard let dataArray = data["list"] as? [[String : AnyObject]] else { return }
        guard let timeShift = data["city"]?["timezone"] as? Int64 else { return }
        var array = [EveryThreeHoursForecastDataModel]()
        dataArray.forEach {
            array.append(EveryThreeHoursForecastDataModel(data: $0, timeShift: timeShift))
        }
        everyThreeHoursForecastData = array
        prepareFiveDaysForecastData(from: array)
    }
    
    private func prepareFiveDaysForecastData(from array: [EveryThreeHoursForecastDataModel]) {
        let objectGroups = Array(Dictionary(grouping:array){$0.day}.values)
        var forecastArray = [FiveDaysForecastDataModel]()
        objectGroups.forEach {
            let dayForecast = FiveDaysForecastDataModel(data: $0)
            forecastArray.append(dayForecast)
        }
        fiveDaysForecastData = forecastArray.sorted(by: { $0.date < $1.date })
    }
}
