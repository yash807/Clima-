//
//  WeatherData.swift
//  Clima
//
//  Created by yash mishra on 26/07/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable{
    let temp: Double
}
struct Weather: Codable{
    let id: Int
}


