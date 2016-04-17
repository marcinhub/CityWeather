//
//  ViewController.swift
//  Poly Weather
//
//  Created by Marcin Steciuk on 31/10/2015.
//  Copyright © 2015 MarcinS. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UITableViewController, WeatherServiceDelegate, CLLocationManagerDelegate {
    
//    let weatherLocations = [("cityName", "temper", "description")]
    
    let weatherLocations = ["currentLocation", "NewYork", "Shanghai", "Paris", "Sydney"]
    
    var currentCity : Weather?

    // creating an instance of WeatherService class
    let weatherService = WeatherService()
    
    var cityObjects : [Weather]?
    var multiCityDataHasBeenDownloaded = false
    var currentCitydataHasBeenDownloaded = false
    
    var locationUpdated = false

    
    var lat : String = ""
    var long : String = ""
    
    var locationManager : CLLocationManager = CLLocationManager()
    var startLocation : CLLocation!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func reloadCells() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? CustomCell
        
        if indexPath.row == 0 {
            if locationUpdated == true {
                dispatch_async(dispatch_get_main_queue()) {
                    cell?.cityLabel!.text = self.currentCity!.cityName
                    cell?.temperatureLabel!.text = "\(self.currentCity!.temp)°"
                    cell?.descriptionLabel!.text = self.currentCity!.description
                    cell?.weatherImageView.image = UIImage(named:"\(self.currentCity!.weatherImage).jpg")
                }
                return cell!
            }
        } else {
            if (self.multiCityDataHasBeenDownloaded == false) {
                return cell!
            } else {
                if let cityArray = self.cityObjects {
                    let city = cityArray[indexPath.row]
                    cell?.cityLabel.text = city.cityName
                    cell?.temperatureLabel.text = "\(city.temp)°"
                    cell?.descriptionLabel.text = city.description
                    
                    switch (indexPath.row) {
                    case 0:
                        cell?.weatherImageView.image = UIImage(named:"\(city.weatherImage).jpg")
                        break
                    case 1:
                        cell?.weatherImageView.image = UIImage(named:"\(city.weatherImage)NY.jpg")
                        break
                    case 2:
                        cell?.weatherImageView.image = UIImage(named:"\(city.weatherImage)S.jpg")
                        break
                    case 3:
                        cell?.weatherImageView.image = UIImage(named:"\(city.weatherImage)P.jpg")
                        break
                    case 4:
                        cell?.weatherImageView.image = UIImage(named:"\(city.weatherImage)SY.jpg")
                        break
                    default:
                        break
                    }
                }
                return cell!
            }
        
        }
        return cell!
    }


    func locationAvailable(notification:NSNotification) -> Void {
        
        if (self.locationUpdated == false) {
            self.weatherService.getWeatherWithLatAndLong(self.lat, longitude: self.long, completion: { (let city) -> Void in
                self.currentCity = city
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            })
        }
        self.locationUpdated = true
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation = locations[locations.count - 1]
        lat = String (format: "%.4f", latestLocation.coordinate.latitude)
        long = String (format: "%.4f", latestLocation.coordinate.longitude)
        
        NSNotificationCenter.defaultCenter().postNotificationName("LOCATION_AVAILABLE", object: nil, userInfo: nil)
        
//        self.tableView.reloadData()
//        if (self.locationUpdated == false) {
//            self.weatherService.getWeatherWithLatAndLong(lat, longitude: long) { (let city) -> Void in
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.currentCity = city
//                    self.currentCitydataHasBeenDownloaded = true
//                    self.locationUpdated = true
//                    self.tableView.reloadData()
//                }
//            }
//        }
        
        
        if startLocation == nil {
            startLocation = latestLocation 
        }
    }

    @IBAction func setCityTapped(sender: UIButton) {
        print("City Button Tapped")
        openCityAlert()
    }
    
    func openCityAlert(){
        
        // Creating alert controler
        let alert = UIAlertController(title: "City", message: "Enter city name", preferredStyle: UIAlertControllerStyle.Alert)
        // Creating cancel action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        //Creating OK action
        let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action : UIAlertAction) -> Void in
            print("OK")
            let textField = alert.textFields?[0]
            print(textField?.text)
           // self.cityLabel.text = textField?.text!
            let cityName = textField?.text
//            self.weatherService.getWeather(cityName!)
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setValue(cityName, forKey: "cityName")
            defaults.synchronize()
            
            print(defaults)
        }
        
        alert.addAction(ok)
        
        // Adding text field
        
        alert.addTextFieldWithConfigurationHandler { (textField : UITextField) -> Void in
            textField.placeholder = "City Name"
        }
        
        // Presenfing alert controler
        self.presentViewController(alert, animated: true, completion: nil)
    }

    // weather servide delecage function:
    
    func setWeather(weather: Weather) {
       // print("**City \(weather.cityName) temp:\(weather.temp) desc: \(weather.description)")
       //cityLabel.text = weather.cityName
//        temperatureLabel.text = "\(weather.temp)"
//        descriptionLabel.text = weather.description
//        cityButton.setTitle(weather.cityName, forState: .Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.weatherService.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationAvailable:", name: "LOCATION_AVAILABLE", object: nil)

        
//        weatherService.getWeather { (let weatherArray) -> Void in
//            //
//        }
//        
//        weatherService.getWeatherWithLatAndLong(self.lat, longitude: self.long) { (let city) -> Void in
//            //
//        }
//
        weatherService.getWeatherMulti({ (let weatherArray) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.cityObjects = weatherArray
                self.multiCityDataHasBeenDownloaded = true
                self.tableView.reloadData()
            }
        })
    }
}


class CustomCell : UITableViewCell {
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
//    override func prepareForReuse() {
//        self.cityLabel.text = ""
//        self.temperatureLabel.text = ""
//        self.descriptionLabel.text = ""
//    }

}
