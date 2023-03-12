//
//  ListViewCellViewModel.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import Combine

final class ListViewCellViewModel {
    
    //MARK: - Properties
    
    @Published var city: String
    //Subscribe in view
    @Published var cellDataModel: ListViewCellDataModel?
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
                        self.prepareCellDataModel(data: data)
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
                    self.prepareCellDataModel(data: data)
                }
            }
            .store(in: &cancelBag)
    }
    
    //MARK: - Actions
    
    private func prepareCellDataModel(data: [String : AnyObject]) {
        cellDataModel = ListViewCellDataModel(data: data)
    }
}
