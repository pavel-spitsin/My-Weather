//
//  RequestService.swift
//  My Weather
//
//  Created by Pavel
//

import Foundation
import CoreLocation
import UIKit

struct RequestService {
    
    //MARK: - Actions
    
    public func requestCurrentWeatherByLocation(location: CLLocationCoordinate2D, completionBlock: @escaping ([String:AnyObject]?) -> Void) {
        let lat = location.latitude
        let lon = location.longitude
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(Constants().appID)&units=metric")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let currentDataDictionary = self.convertStringToDictionary(text: String(data: data, encoding: .utf8)!)
            completionBlock(currentDataDictionary)
        }
        task.resume()
    }
    
    public func requestFiveDaysForecastByLocation(location: CLLocationCoordinate2D, completionBlock: @escaping ([String:AnyObject]?) -> Void) {
        let lat = location.latitude
        let lon = location.longitude
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(Constants().appID)&units=metric")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let everyThreeHoursDataDictionary = self.convertStringToDictionary(text: String(data: data, encoding: .utf8)!)
            completionBlock(everyThreeHoursDataDictionary)
        }
        task.resume()
    }

    public func requestCurrentWeatherByCityName(name: String, completionBlock: @escaping ([String:AnyObject]?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(name)&appid=\(Constants().appID)&units=metric")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let currentDataDictionary = self.convertStringToDictionary(text: String(data: data, encoding: .utf8)!)
            completionBlock(currentDataDictionary)
        }
        task.resume()
    }
    
    public func requestFiveDaysForecastByCityName(name: String, completionBlock: @escaping ([String:AnyObject]?) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(name)&appid=\(Constants().appID)&units=metric")!
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let everyThreeHoursDataDictionary = self.convertStringToDictionary(text: String(data: data, encoding: .utf8)!)
            completionBlock(everyThreeHoursDataDictionary)
        }
        task.resume()
    }
    
    public func imageRequest(for imageView: UIImageView, iconID: String, completion: (() -> Void)?) {
        let imageURL: URL = URL(string: "https://openweathermap.org/img/wn/\(iconID)@2x.png")!
        let queue = DispatchQueue.global(qos: .background)
        queue.async {
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    imageView.image = image
                    guard let function = completion else { return }
                    function()
                }
            }
        }
    }

    private func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
}
