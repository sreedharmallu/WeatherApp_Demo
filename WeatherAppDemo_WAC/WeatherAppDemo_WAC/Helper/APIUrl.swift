//
//  APIUrl.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import Foundation

public enum APIURL {
    case getWeatherDetails(lattitude: Double, longitude: Double)
    case getWeatherImage(icon: String)
    var urlString: String {
        switch self {
        case .getWeatherDetails(lattitude: let lat, longitude: let lon):
            return "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=b38886f67d858cdb8b9f7dafd5e66ae6"
        case .getWeatherImage(icon: let icon):
            return "https://openweathermap.org/img/wn/\(icon)@2x.png"
        }
    }
}
