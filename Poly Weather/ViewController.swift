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
    
    let weatherLocations = ["currentLocation", "NewYork", "Shanghai", "Moscow", "Sydney"]

    // creating an instance of WeatherService class
    let weatherService = WeatherService()
    
    
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? CustomCell
        
        let weatherLocation = weatherLocations[indexPath.row]
        
        if (indexPath.row == 0) {
            weatherService.getWeatherWithLatAndLong(lat, longitude: long, completion: { (let weather) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    cell?.cityLabel.text = weather.cityName
                    cell?.temperatureLabel.text = "\(weather.temp)"
                    cell?.descriptionLabel.text = weather.description
                    cell?.weatherImageView.image = UIImage(named:"clouds.jpg")
                }
            })
            
        } else {
            weatherService.getWeather(weatherLocation, completion: { (let weather) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    cell?.cityLabel.text = weather.cityName
                    cell?.temperatureLabel.text = "\(weather.temp)"
                    cell?.descriptionLabel.text = weather.description
                    cell?.weatherImageView.image = UIImage(named:"clouds.jpg")
                }
            })
        }
        
        
        
//        let (city, temperat, descript) = weatherLocations[indexPath.row]
        
//        cell.textLabel?.text = city
        //cell.textLabel!.text = temperat
//        cell.detailTextLabel?.text = descript
        
        return cell!
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation = locations[locations.count - 1]
        lat = String (format: "%.4f", latestLocation.coordinate.latitude)
        long = String (format: "%.4f", latestLocation.coordinate.longitude)
        
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
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

        
        let defaults = NSUserDefaults.standardUserDefaults()
      
        
        if let cityDefault = defaults.stringForKey("cityName") {
//            self.weatherService.getWeather(cityDefault)
        }
        else{
        openCityAlert()}

        
    
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
