//
//  WeatherManager.swift
//  Clima
//
//  Created by yash mishra on 25/07/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4f4fb51948eca3fd768ff43084a67286&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    
    
    func performRequest(with urlString: String){
        //step1: Create a url
        
        if let url = URL(string: urlString){
            
            //step2 : create a url session
            let session = URLSession(configuration: .default)
            //step 3: Give the session a task
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
            }
            //step 4: start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
            return weather

        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
   
    
    
}



