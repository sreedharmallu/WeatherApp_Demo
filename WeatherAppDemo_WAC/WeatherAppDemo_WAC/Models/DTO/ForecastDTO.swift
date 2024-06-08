//
//  ForecastDTO.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//


import Foundation

struct ForecastDTO: Codable {
    let list: [Daily]
    let city: City
}

extension ForecastDTO {
    struct Daily: Codable {
        let dt: Date
        let main: Temp
        let weather: [Weather]
        let clouds: Clouds
        let wind: Wind
        let pop: Double
    }
    
    struct City: Codable {
        let name: String
        let country: String
    }
}

extension ForecastDTO.Daily {
    struct Temp: Codable {
        let temp: Double
        let humidity: Int
    }
    
    struct Weather: Codable {
        let id: Int
        let description: String
        let icon: String
    }
    
    struct Clouds: Codable {
        let all: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}
