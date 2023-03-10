 //
//  WeatherModel.swift
//  Clima
//
//  Created by Pavel Reshetov on 27.01.2023.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String {
        return String(format: "%.f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232: return "cloud.bolt.rain"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...721: return "smoke"
        case 731...761: return "sun.dust"
        case 762: return "aqi.low"
        case 771: return "wind"
        case 781: return "tornado"
        case 800: return "sun.max"
        case 801...804: return "cloud"
        default: return "cloud"
             
        }
    }
}
