//
//  ViewController+Data.swift
//  WeatherApp
//
//  Created by Nguyen Tien Hai on 8/29/17.
//  Copyright © 2017 Nguyen Tien Hai. All rights reserved.
//

import UIKit


extension ViewController {
    func getCityWeatherData(stringCity: String, completion: @escaping (_ weather: Double, _ desc: String, _ icon: String, _ lat: Double, _ lon: Double) -> ()) {
        
        let cityFiltered: String = stringCity.replacingOccurrences(of: " ", with: "+")
        
        let url:URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityFiltered)&appid=\(apiID)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                if let dataValid = data {
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: dataValid, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        //print(jsonDict)
                        
                        let coord = jsonDict["coord"] as! NSDictionary
                        let latCoord = coord["lat"] as! Double
                        let lonCoord = coord["lon"] as! Double
                        
                        let weather = jsonDict["weather"] as! NSArray
                        let weather0 = weather[0] as! NSDictionary
                        let desc = weather0["description"] as! String
                        let icon = weather0["icon"] as! String
                        
                        let main = jsonDict["main"] as! NSDictionary
                        let temp = main["temp"] as! Double
                        let tempCelsius = temp - 273.15
                        
                        DispatchQueue.main.async(execute: {
                            completion(tempCelsius, desc, icon, latCoord, lonCoord)
                        })
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    func downloadWeatherIcon(iconId: String, completion: @escaping (_ imgData: Data) -> ()) {
        
        let url:URL = URL(string: "http://openweathermap.org/img/w/\(iconId).png")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let dataOk = data {
                    do {
                        DispatchQueue.main.async(execute: {
                            completion(dataOk)
                        })
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getTimeZoneId(lat: Double, lon: Double, completion: @escaping (_ identifier: String) -> ()) {
        
        let key = "AIzaSyDbp5frHA0KhAeSTrRQzWrFsxyEPXgiff0"
        let url: URL = URL(string: "https://maps.googleapis.com/maps/api/timezone/json?location=\(lat),\(lon)&timestamp=1331161200&key=\(key)")!
        var identifier: String?
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                if let dataOk = data {
                    
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: dataOk, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        identifier = jsonDict["timeZoneId"] as! String
                        
                        DispatchQueue.main.async(execute: {
                            completion(identifier!)
                        })
                        
                    } catch {
                        
                    }
                }
            }
        }
        task.resume()
    }
    
}
