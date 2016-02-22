//
//  WeatherService.swift
//  Poly Weather
//
//  Created by Marcin Steciuk on 31/10/2015.
//  Copyright © 2015 MarcinS. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather: Weather)
    
}

class WeatherService{
    
    var delegate: WeatherServiceDelegate?
    typealias weatherCompletion = (Weather) -> Void
    
    func getWeatherWithLatAndLong(latitude: String, longitude: String, completion : weatherCompletion){
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=2ab2395d40cc7956cc7bb9d13a2b1776"

        let url = NSURL(string: path)
        self.downloadWeatherDataWithURL(url!) { (let weather) -> Void in
            completion(weather)
        }
        
    }
    
    
    func getWeather(city: String, completion : weatherCompletion){
        
        //alowing empty space in city name
        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        //geting data from openweathermap
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
        let url = NSURL(string: path)
        //let path = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
        self.downloadWeatherDataWithURL(url!) { (let weather) -> Void in
            completion(weather)
        }
        
    }
    
    func downloadWeatherDataWithURL(url : NSURL, completion : weatherCompletion){

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            //print("*** \(data)")
            let json = JSON(data: data!)
            let lon = json["coord"]["lon"].double
            let lat = json["coord"]["lat"].double
            var temp = json["main"]["temp"].double
            let name = json["name"].string
            let desc = json["weather"][0]["description"].string
            let weatherImg = json["weather"][0]["icon"].string
            
            if let temperature = temp {
                var newTemp = temperature
                newTemp = temp! - 273.15
                var intTemp:Int = Int(newTemp)
                let weather = Weather(cityName: name!, temp: intTemp, description: desc!, weatherImage: weatherImg!)
                
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    if self.delegate != nil {
//                        self.delegate?.setWeather(weather)
//                    }
//                })
                
                completion(weather)
                
//                print("lat \(lat!) lon \(lon!) temp \(temp!)")
            }
            
        }
        
        task.resume()
    }
    
}