//
//  SaveLoadService.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import RealmSwift

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
        let realm = try! Realm()
        var loadedCities = [String]()
        realm.objects(City.self).forEach {
            loadedCities.append($0.name)
        }
        return loadedCities
    }
    
    public func save(cities: [String]) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        cities.forEach {
            let city = City(name: $0)
            try! realm.write {
                realm.add(city)
            }
        }
    }
}

final class City: Object {
    @objc dynamic var name: String = ""
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
