//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nguyen Tien Hai on 8/27/17.
//  Copyright © 2017 Nguyen Tien Hai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gradientImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func openDialog(_ sender: Any) {
        alertDialog()
    }
    
    var apiID: String = "a433dc7d118105a693cdbc11d51cd2de"
    var localIdentifier:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localId = "Asia/Saigon"
        
        displayBackground()
        
        // Setup date & time
        self.dateLabel.text = dateFromLocation(identifier: localId)
        self.timeLabel.text = timeFromLocation(identifier: localId)
        
        // Update time
        self.localIdentifier = localId
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        
        // Download data from api
        getCityWeatherData(stringCity: "hanoi") { (temp, desc, icon, lat, lon) in
            //print("The temp is \(temp) : \(desc)")
            //print("Lat: \(lat), Long: \(lon)")
            self.descLabel.text = desc
            self.tempLabel.text = "\(Int(temp))°"
            self.downloadWeatherIcon(iconId: icon, completion: { (data) in
                self.iconImageView.image = UIImage(data: data)
            })
        }
        
        // Navigation bar transparent
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
    }

    func alertDialog() {
        let alert = UIAlertController(title: "Select City", message: "", preferredStyle: .alert)
        var cityField: UITextField?
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            cityField = alert.textFields?[0]
            self.changeCity(city: (cityField?.text)!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addTextField { (cityField) in
            cityField.placeholder = "City ..."
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func changeCity(city: String) {
        getCityWeatherData(stringCity: city) { (temp, desc, icon, lat, lon) in
            self.descLabel.text = desc
            self.tempLabel.text = "\(Int(temp))°"
            self.cityLabel.text = city.capitalized
            
            self.downloadWeatherIcon(iconId: icon, completion: { (data) in
                self.iconImageView.image = UIImage(data: data)
            })
            self.getTimeZoneId(lat: lat, lon: lon, completion: { (timeZoneId) in
                //print("Time zone for \(city): \(timeZoneId)")
                self.localIdentifier = timeZoneId
                self.dateLabel.text = self.dateFromLocation(identifier: timeZoneId)
                self.timeLabel.text = self.timeFromLocation(identifier: timeZoneId)
            })
        }
    }
    
    func displayBackground() {
        let index = arc4random_uniform(UInt32(5))
        gradientImageView.image = UIImage(named: "gradient\(index).jpg")
    }
    
    func dateFromLocation(identifier: String) -> String {
        var dateStr: String?
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.timeZone = TimeZone(identifier: identifier)
        
        dateStr = dateFormatter.string(from: currentDate)
        return dateStr!
    }
    
    func timeFromLocation(identifier: String) -> String {
        var timeStr: String?
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: identifier)
        
        timeStr = dateFormatter.string(from: currentDate)
        return timeStr!
    }
    
    func updateTime() {
        let currentDate = Date()
        let dateFomatter = DateFormatter()
        dateFomatter.dateFormat = "hh:mm a"
        dateFomatter.timeZone = TimeZone(identifier: localIdentifier!)
        timeLabel.text = dateFomatter.string(from: currentDate)
    }

}














