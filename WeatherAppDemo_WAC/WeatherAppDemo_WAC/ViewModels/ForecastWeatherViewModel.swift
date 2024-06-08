//
//  ForecastListViewModel.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import SwiftUI
import CoreLocation

class ForecastListViewModel: ObservableObject {
    
    @Published var forecasts: [ForecastViewModel] = []
    @Published var appError: AppError? = nil
    @Published var isLoading: Bool = false
    @Published var location = ""
    
    private let locationUnknownError = "Unable to determine location from this text."
    private let networkError = "You do not appear to have a network connection."
    private let windStatus = "Wind Status"
    private let humidity = "Humidity"
    private let clouds = "Clouds"
    private let pop = "POP"
    
    init() {
        location = .defaultCity
        getWeatherForecast()
    }
    
    var currentForecastDetails: ForecastViewModel? {
        return forecasts.isEmpty ? nil : forecasts[0]
    }
    
    var currentWeatherDetails: [CurrentWeatherDetailsItem] {
        guard !forecasts.isEmpty else { return [] }
        let currentForeCast = forecasts[0]
        
        return [.init(title: windStatus, value: currentForeCast.wind),
                .init(title: humidity, value: currentForeCast.humidity),
                .init(title: clouds, value: currentForeCast.clouds),
                .init(title: pop, value: currentForeCast.pop)]
    }
    
    func getWeatherForecast() {
        UIApplication.shared.endEditing()
        if location == "" {
            forecasts = []
        } else {
            isLoading = true
            CLGeocoder().geocodeAddressString(location) { [weak self] (placemarks, error) in
                guard let self else { return }
                if let error = error as? CLError {
                    self.assignAppError(error: error)
                }
                self.fetchSelectedCityWeatherAppDetails(placemarks: placemarks)
            }
            
        }
    }
    
    private func assignAppError(error: CLError) {
        switch error.code {
        case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
            self.appError = AppError(errorString: NSLocalizedString(locationUnknownError,
                                                                    comment: ""))
        case .network:
            self.appError = AppError(errorString: NSLocalizedString(networkError,
                                                                    comment: ""))
        default:
            self.appError = AppError(errorString: error.localizedDescription)
        }
        self.isLoading = false
        
        print(error.localizedDescription)
    }
    
    private func setForecastDetails(forecast: ForecastDTO) {
        var dates: [String] = []
        self.forecasts = forecast.list.map { ForecastViewModel(forecast: $0,
                                                               city: forecast.city)}
        .filter({ forecast in
            if !dates.contains(forecast.day) {
                dates.append(forecast.day)
                return true
            }
            return false
        })
    }
    
    private func fetchSelectedCityWeatherAppDetails(placemarks: [CLPlacemark]?) {
        if let lat = placemarks?.first?.location?.coordinate.latitude,
           let lon = placemarks?.first?.location?.coordinate.longitude {
            
            let apiUrl: APIURL = .getWeatherDetails(lattitude: lat, longitude: lon)
            
            let apiService = APIService.shared
            
            apiService.getJSON(apiUrl: apiUrl,
                               dateDecodingStrategy: .secondsSince1970) { (result: Result<ForecastDTO,APIService.APIError>) in
                switch result {
                case .success(let forecast):
                    DispatchQueue.main.async {[weak self] in
                        guard let self else { return }
                        self.isLoading = false
                        self.setForecastDetails(forecast: forecast)
                    }
                case .failure(let apiError):
                    switch apiError {
                    case .error(let errorString):
                        self.isLoading = false
                        self.appError = AppError(errorString: errorString)
                        print(errorString)
                    }
                }
            }
        }
    }
}

