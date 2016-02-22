//
//  Weather.swift
//  Poly Weather
//
//  Created by Marcin Steciuk on 31/10/2015.
//  Copyright © 2015 MarcinS. All rights reserved.
//

import Foundation

struct Weather {
    let cityName : String
    let temp : Int
    let description : String
    let weatherImage : String
    
    init(cityName: String, temp: Int, description: String, weatherImage: String){
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.weatherImage = weatherImage
    }
    
}