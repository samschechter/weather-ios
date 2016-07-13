//
//  ViewController.swift
//  Weather
//
//  Created by Sam Schechter on 3/23/16.
//  Copyright © 2016 Sam Schechter. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, GooglePlacesAutocompleteDelegate {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var forecast: Forecast?
    var locationManager = CLLocationManager()
    var gpaViewController: GooglePlacesAutocomplete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
    

        //let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.backgroundView = UIView()
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = UIView()
        
        self.navigationController?.presentTransparentNavigationBar()
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        locationManager.stopUpdatingLocation()
        
        Forecast().fetch(fetched, failure: failed, loc: newLocation)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetched(forecast: Forecast) {
        self.forecast = forecast
        self.tableView.reloadData()
        self.collectionView.reloadData()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        
        dateLabel.text = dateFormatter.stringFromDate(NSDate())
        
        if let _  = forecast.location {
            CLGeocoder().reverseGeocodeLocation(forecast.location!, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    print(pm.locality)
                    
                    var locationName = String()
                    
                    if let locality = pm.locality {
                        locationName.appendContentsOf(locality)
                    }
                    
                    if let adminArea = pm.administrativeArea {
                        locationName.appendContentsOf(", " + adminArea)
                    }
                    
            
                    self.title = locationName
                    //self.locationNameLabel.text = locationName
                    
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
        } else {
            print("Wtf")
        }
        
        guard let currentForecast = forecast.currentForecast else {
            return;
        }
        
        if let temperature = currentForecast.temperature {
            
            let s = String(format: "%.0f", temperature)
            temperatureLabel.text = s  + "º"
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
        

    }
    
    func failed(error: String) {
        
    }
}


// MARK: CollectionView
extension ViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let _ = forecast, let hours = forecast?.hours {
            return hours.count
        } else {
            return 0
        }
    
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("collectionView row:", indexPath.row)
        let cellIdentifier = "HourCollectionViewCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! HourCollectionViewCell
        
        guard let _ = forecast, let hours = forecast?.hours, let hour = hours[indexPath.row] as? Forecast.Hour else {
            return cell
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h"
        
        cell.tempLabel.text = String(format:"%.0f", hour.temperature!) + "º"
        
        if let time = hour.time {
            let hourString = dateFormatter.stringFromDate(time) + " PM"
            cell.hourLabel.text = hourString
        }
        
        if let precip = hour.precipProbability {
                cell.precipLabel.text = String(format:"%.0f", precip) + "%"
        }
        
        return cell
        
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
        
        
        //cell.containerView.layer.borderColor = UIColor(white:0.93, alpha:1.0).CGColor//UIColor.lightGrayColor().CGColor
        
        guard let _ = forecast, let days = forecast?.days, let day = days[indexPath.row] as? Forecast.Day else {
            return cell
        }
            
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d"
        
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
        
        if let iconKey = day.icon, let iconString = Forecast.Icons[iconKey] {
            let origImage = UIImage(named: iconString)
            let tintedImage = origImage?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.weatherImage.image = tintedImage
            cell.weatherImage.tintColor = UIColor.grayColor()
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    
// MARK: Location select
    @IBAction func navigateToPlaceSelect(sender: AnyObject) {
        self.gpaViewController = GooglePlacesAutocomplete(
            apiKey: "AIzaSyALqO46ja6RBhdSDZ9BlkPu8KZCvG6kyjA",
            placeType: .Cities
        )
        
        self.gpaViewController!.placeDelegate = self // Conforms to GooglePlacesAutocompleteDelegate
        
        self.gpaViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(ViewController.locationViewClosed))
        
        self.gpaViewController!.navigationItem.title = "Select a Location"
        self.gpaViewController!.navigationItem.leftBarButtonItem?.tintColor = UIColor.blackColor()
        self.gpaViewController!.navigationController?.presentTransparentNavigationBar()
        
        let button = UIButton()
        button.frame = CGRectMake(0, 0, 26, 26) //won't work if you don't set frame
        button.setImage(UIImage(named: "my_location"), forState: .Normal)
        button.addTarget(self, action: #selector(ViewController.useMyLocation), forControlEvents: .TouchUpInside)
        
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.gpaViewController!.navigationItem.rightBarButtonItem = barButton
        
        presentViewController(self.gpaViewController!, animated: true, completion: nil)
    }
    
    func placeSelected(place: Place) {
        place.getDetails { (details) in
            
            let location = CLLocation(latitude: details.latitude, longitude: details.longitude)
            Forecast().fetch(self.fetched, failure: self.failed, loc: location)
            
            self.gpaViewController!.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func locationViewClosed(){
        self.gpaViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func useMyLocation(){
        locationManager.startUpdatingLocation()
        self.gpaViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UINavigationController {
    public func presentTransparentNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics:UIBarMetrics.Default)
        navigationBar.translucent = true
        navigationBar.shadowImage = UIImage()
        setNavigationBarHidden(false, animated:true)
    }
}

