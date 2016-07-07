//
//  Forecast.swift
//  Weather
//
//  Created by Sam Schechter on 3/23/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

class Forecast {
    var currentForecast: Current?
    var hours = [Hour]()
    var location: CLLocation?
    var days = [Day]()
    
    struct Current {
        var summary: String?
        var temperature: Double? = 0
        var humidity: Double? = 0
        var windSpeed: Double? = 0
        
        init(obj: NSDictionary){
            
            if let summary = obj["summary"] as? String {
                self.summary = summary
            }
            temperature = obj["temperature"] as? Double!
            humidity = obj["humidity"] as? Double!
            windSpeed = obj["windSpeed"] as? Double!
        }
    }
    
    struct Hour {
        var time: NSDate?
        var icon: String?
        var temperature: Double?
        var precipProbability: Double?
        
        init(hour: NSDictionary){
            self.icon = hour["icon"] as? String
            self.temperature = hour["temperature"] as? Double
            self.precipProbability = hour["precipProbability"] as? Double
            
            if let time = hour["time"] as? Double {
                self.time = NSDate(timeIntervalSince1970: time)
            }
        }
    }
    
    struct Day {
        var time: NSDate?
        var icon: String?
        var temperatureMax: Double?
        var temperatureMaxTime: NSDate?
        var temperatureMin: Double?
        var temperatureMinTime: NSDate?
        var precipProbability: Double?
        
        init(day: NSDictionary){
            self.icon = day["icon"] as? String
            self.temperatureMax = day["temperatureMax"] as? Double
            
            if let time = day["temperatureMaxTime"] as? Double {
                self.temperatureMaxTime = NSDate(timeIntervalSince1970: time)
            }
            
            if let time = day["temperatureMinTime"] as? Double {
                self.temperatureMinTime = NSDate(timeIntervalSince1970: time)
            }
            
            self.temperatureMin = day["temperatureMin"] as? Double
            self.precipProbability = day["precipProbability"] as? Double
            
            if let time = day["time"] as? Double {
                self.time = NSDate(timeIntervalSince1970: time)
            }
        }
    }
    

    
    func fetch(success: (Forecast) -> Void, failure: (String) -> Void, loc: CLLocation){
        let url = "https://api.forecast.io/forecast/ccefe2c2d217ae19e40a0c27fa09c6da/" + String(loc.coordinate.latitude) + "," + String(loc.coordinate.longitude)
        print(url)
        self.location = loc
        
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                print(response.request)  // original URL request
                //print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
                
                switch response.result {
                case .Success(let data):
                    let json = response.result.value as! NSDictionary
                    
                    
                    
                    guard let currentlyObj = json["currently"] as? NSDictionary else {
                        return
                    }
                
                    self.currentForecast = Current(obj: currentlyObj)

                    if let d = json["daily"] as? NSDictionary, let dailyObjs = d["data"] as? NSArray {
                        for day in dailyObjs {
                            if let d = day as? NSDictionary {
                                self.days.append(Day(day: d))
                            }
                        }
                    }
                    
                    if let h = json["hourly"] as? NSDictionary, let hourlyObjs = h["data"] as? NSArray {
                        for hour in hourlyObjs {
                            if let h = hour as? NSDictionary {
                                self.hours.append(Hour(hour: h))
                            }
                        }
                    }
                    
                    success(self)
                    
                case .Failure(let error):
                    print("called failed")
                    failure("failed")
                }
                
                
        }
    }
}
