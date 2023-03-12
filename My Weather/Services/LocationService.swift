//
//  LocationService.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import CoreLocation
import Combine

final class LocationService: NSObject {
    
    //MARK: - Properties
    
    static let shared = LocationService()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    //MARK: - Init
    
    override private init() {}
    
    //MARK: - Actions
    
    public func askUserForAuthorisation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func locationRequest() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
}

    //MARK: - Extensions

//MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = manager.location?.coordinate else { return }
        currentLocation = locValue
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
}
