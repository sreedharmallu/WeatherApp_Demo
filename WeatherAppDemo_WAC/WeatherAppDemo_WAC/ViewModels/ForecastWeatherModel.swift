//
//  ForecastModel.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import Foundation

struct ForecastViewModel {
    let forecast: ForecastDTO.Daily
    let city: ForecastDTO.City
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, YYYY"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }

    private func convert(_ temp: Double) -> Double {
        let celsius = temp - 273.5
        return celsius
    }
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    var wind: String {
        return "\(Self.numberFormatter.string(for: forecast.wind.speed) ?? "0") mph"
    }

    var pop: String {
        return "💧 \(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var cityName: String {
        return city.name
    }
    
    var countryName: String {
        return city.country
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds.all)%"
    }

    var humidity: String {
        return "\(forecast.main.humidity)%"
    }
    
    var currentTemp: String {
        "\(Self.numberFormatter.string(for: convert(forecast.main.temp)) ?? "0") °C"
    }
    
    var weekDay: String {
        let weekDays = Calendar.current.weekdaySymbols
        let day = Calendar.current.component(.weekday, from: forecast.dt)
        return weekDays[day-1]
    }
    
    var weatherIconURL: URL {
        if !forecast.weather.isEmpty {
            let apiUrl: APIURL = .getWeatherImage(icon: forecast.weather[0].icon)
            return URL(string: apiUrl.urlString)!
        } else {
            let apiUrl: APIURL = .getWeatherImage(icon: "04d")
            return URL(string: apiUrl.urlString)!
        }
    }
}

struct CurrentWeatherDetailsItem {
    let title: String
    let value: String
}
