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
    typealias weatherArrayCompletion = ([Weather]) -> Void
    typealias data = (NSData?) -> Void

    
    func getWeatherWithLatAndLong(latitude: String, longitude: String, completion : weatherCompletion){
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
        print(path)

        let url = NSURL(string: path)
        self.downloadWeatherDataWithURL(url!) { (let data) -> Void in
           let json = JSON(data: data!)
            
            let temp = json["main"]["temp"].double
            let celciusTemp = self.tempToCelsius(temp!)
            let desc = json["weather"][0]["description"].string
            let weatherImg = json["weather"][0]["icon"].string
            let name = json["name"].string
            let weather = Weather(cityName: name!, temp: celciusTemp, description: desc!, weatherImage: weatherImg!)
            completion(weather)
        }
        
    }
    
    func getWeather(completion: weatherArrayCompletion) {
        //getmultiURL
        //getLat&LongURL
//        self.getWeatherMulti { (<#[Weather]#>) -> Void in
//            //
//        }
//        self.getWeatherWithLatAndLong(<#T##latitude: String##String#>, longitude: <#T##String#>, completion: <#T##weatherCompletion##weatherCompletion##(Weather) -> Void#>)
    }
    
//    func getWeather(city: String, completion : weatherCompletion){
//        
//        //alowing empty space in city name
//        let cityEscaped = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
//        
//        //geting data from openweathermap
//        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(cityEscaped!)&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
//        let url = NSURL(string: path)
//        //let path = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
//        self.downloadWeatherDataWithURL(url!) { (let weather) -> Void in
//            completion(weather)
//        }
//    }
    
    func getWeatherMulti(completion : weatherArrayCompletion){
        
        
        //alowing empty space in city name
        //let cityID //= city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        //find city ID for current Location
        var cityID : String = "6058560"
        //geting data from openweathermap
        let pathMultiCity = "http://api.openweathermap.org/data/2.5/group?id=\(cityID),5128581,1796236,6942553,2147714&units=metric&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
        let url = NSURL(string: pathMultiCity)
        //let path = "http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=2ab2395d40cc7956cc7bb9d13a2b1776"
        self.downloadWeatherDataWithURL(url!) { (let data) -> Void in
            
            let json = JSON(data: data!)
            let lon = json["coord"]["lon"].double
            let lat = json["coord"]["lat"].double
            
            var temp = json["main"]["temp"].double
            let desc = json["weather"][0]["description"].string
            let weatherImg = json["weather"][0]["icon"].string
            
            //getting weather conditions for 5 cities:
            var temp1 = json["list"][0]["main"]["temp"].double
            let desc1 = json["list"][0]["weather"][0]["description"].string
            let weatherImg1 = json["list"][0]["weather"][0]["icon"].string
            
            var temp1Int:Int = Int(temp1!)
            
            print("response from temp1 is \(temp1Int)")
            print("response from desc1 is \(desc1)")
            print("response from weatherImg1 is \(weatherImg1)")
            
            var temp2 = json["list"][1]["main"]["temp"].double
            let desc2 = json["list"][1]["weather"][0]["description"].string
            let weatherImg2 = json["list"][1]["weather"][0]["icon"].string
            
            var temp2Int:Int = Int(temp2!)
            
            print("response from temp1 is \(temp2Int)")
            print("response from desc1 is \(desc2)")
            print("response from weatherImg1 is \(weatherImg2)")
            
            var temp3 = json["list"][2]["main"]["temp"].double
            let desc3 = json["list"][2]["weather"][0]["description"].string
            let weatherImg3 = json["list"][2]["weather"][0]["icon"].string
            
            var temp3Int:Int = Int(temp3!)
            
            print("response from temp1 is \(temp3Int)")
            print("response from desc1 is \(desc3)")
            print("response from weatherImg1 is \(weatherImg3)")
            
            var temp4 = json["list"][3]["main"]["temp"].double
            let desc4 = json["list"][3]["weather"][0]["description"].string
            let weatherImg4 = json["list"][3]["weather"][0]["icon"].string
            
            var temp4Int:Int = Int(temp4!)
            
            print("response from temp1 is \(temp4Int)")
            print("response from desc1 is \(desc4)")
            print("response from weatherImg1 is \(weatherImg4)")
            
            var temp5 = json["list"][4]["main"]["temp"].double
            let desc5 = json["list"][4]["weather"][0]["description"].string
            let weatherImg5 = json["list"][4]["weather"][0]["icon"].string
            
            var temp5Int:Int = Int(temp5!)
            
            print("response from temp1 is \(temp5Int)")
            print("response from desc1 is \(desc5)")
            print("response from weatherImg1 is \(weatherImg5)")
            
            
            let name = "hello"
            //            let name = json["name"].string
            //            print("name from url is \(name)")
            //            if let temperature = temp {
            //                var newTemp = temperature
            //                newTemp = temp! - 273.15
            //                var intTemp:Int = Int(newTemp)
            //            }
            
            //            let weather = Weather(cityName: name!, temp: temp1Int, description: desc1!, weatherImage: weatherImg1!)
            let weather2 = Weather(cityName: "NewYork", temp: temp2Int, description: desc2!, weatherImage: weatherImg2!)
            let weather3 = Weather(cityName: "Shanghai", temp: temp3Int, description: desc3!, weatherImage: weatherImg3!)
            let weather4 = Weather(cityName: "Paris", temp: temp4Int, description: desc4!, weatherImage: weatherImg4!)
            let weather5 = Weather(cityName: "Sydney", temp: temp5Int, description: desc5!, weatherImage: weatherImg5!)
            
            let weatherArray = [weather2, weather2, weather3, weather4, weather5]
            completion(weatherArray)
        }
        
        
    }
    /*
    func tempToCelsius (tempF: Double) -> Int{
        //if let temperature = TempF {
        var newTemp = tempF
        newTemp = newTemp - 273.15
        var intTemp:Int = Int(newTemp)
        
        return intTemp
    }
    */
    func tempToCelsius (TempF: Double) -> Int{
        //if let temperature = TempF {
        let newTemp = Int(TempF - 273.15)
        return newTemp
    }

    
    func downloadWeatherDataWithURL(url : NSURL, completion : data){

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { (data : NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            //print("*** \(data)")
            
            //getWeatherForCurrentLocation
            completion(data)
        }
        
        task.resume()
    }
    
}