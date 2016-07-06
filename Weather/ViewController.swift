//
//  ViewController.swift
//  Weather
//
//  Created by Sam Schechter on 3/23/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hourlyController: HourlyController!
    
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Forecast().fetch(fetched, failure: failed)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetched(forecast: Forecast) {
        self.forecast = forecast
        self.tableView.reloadData()
        
        guard let currentForecast = forecast.currentForecast else {
            return;
        }
        
        if let temperature = currentForecast.temperature {
            
            let s = String(format: "%.0f", temperature)
            temperatureLabel.text = s//substring(tempString, i: 2)
        }
        
        
        if let summary = currentForecast.summary {
            summaryLabel.text = summary
        }
        
        if let windSpeed = currentForecast.windSpeed {
            windLabel.text = "Wind: " + String(format: "%.2f", windSpeed) + "mph"
        }
        
        if let humidity = currentForecast.humidity {
            humidityLabel.text = "Humidity: " + String(format: "%.0f", humidity*100) + "%"
        }
        
        hourlyController.setHours(hours: forecast.hours)

    }
    
    func failed(error: String) {
        
    }

}

// MARK: Tableview
extension ViewController {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of table rows
        if let _ = forecast, let _ = forecast?.days {
            return forecast!.days.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("tableview row:", indexPath.row)
        let cellIdentifier = "DayTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DayTableViewCell
        
        guard let _ = forecast, let days = forecast?.days, let day = days[indexPath.row] as? Forecast.Day else {
            return cell
        }
            
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        if let _ = day.time {
            let dayOfWeekString = dateFormatter.stringFromDate(day.time!)
            cell.dayLabel.text = dayOfWeekString
        }

        cell.hiLabel.text = String(format:"%.0f", day.temperatureMax!) + "º"
        cell.loLabel.text = String(format:"%.0f", day.temperatureMin!) + "º"
        
        dateFormatter.dateFormat = "h a"
        
        if let _ = day.temperatureMaxTime {
            cell.hiTime.text = dateFormatter.stringFromDate(day.temperatureMaxTime!)
        }
        
        if let _ = day.temperatureMinTime {
            cell.loTime.text = dateFormatter.stringFromDate(day.temperatureMinTime!)
        }

        
        let s = day.precipProbability!*100
        cell.precipLabel.text = String(format:"%.0f", s) + "%"
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
}

