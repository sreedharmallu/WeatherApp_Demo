//
//  WAStrings.swift
//  WeatherAppDemo_WAC
//
//  Created by GGKU5MACBOOKPRO029 on 08/06/24.
//

import Foundation

extension String {
    static let empty = "EMPTY"
    static let defaultCity = "Hyderabad"
    static let defaultCountry = "IN"
    static let loadingViewTitle = "Fetching Weather"
    
    struct Dashboard {
        static let bottomViewTitle = "The Next 3 days"
        static let textFieldPlaceholder = "Please Enter Your City Name"
    }
    
    struct Error {
        static let error = "Error"
        static let unKnownError = "Un-Known Error"
    }
}
