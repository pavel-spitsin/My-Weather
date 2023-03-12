//
//  SaveLoadService.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation

final class SaveLoadService {
    
    //MARK: - Properties
    
    static let shared = SaveLoadService()
    
    var cities = ["My location"] {
        didSet {
            save(cities: cities)
        }
    }
    
    //MARK: - Init
    
    private init() {
        if load().count != 0 {
            cities = load()
        }
    }
    
    //MARK: - Actions
    
    public func load() -> [String] {
        var loadedCities = [String]()
        if let data = UserDefaults.standard.data(forKey: "Cities") {
            do {
                let decoder = JSONDecoder()
                let cities = try decoder.decode([String].self, from: data)
                loadedCities = cities
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return loadedCities
    }
        
    public func save(cities: [String]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(cities)
            UserDefaults.standard.set(data, forKey: "Cities")
        } catch {
            print("Unable to Cities (\(error))")
        }
    }
}
