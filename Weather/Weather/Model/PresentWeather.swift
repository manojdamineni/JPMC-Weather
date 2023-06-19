//
//  PresentWeather.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import Foundation

// MARK: - PresentWeather
struct PresentWeather: Codable, Identifiable {
    let weather: [WeatherElement]?
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let date: Int?
    let id: Int?
    let name: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case weather
        case base
        case main
        case visibility
        case wind
        case rain
        case date = "dt"
        case id
        case name
        case message
    }
}

struct Main: Codable {
    let temparature: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let humidity: Int?
    let seaLevel: Int?
    let groundLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temparature = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
    }
}

struct WeatherElement: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
        case icon
    }
}

struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}

//MARK: - Formatted Weather
struct WeatherFormatted {
    var temparature: String = ""
    var condition: String = ""
    var description: String = ""
    var imageURL: String = ""
    var feelsLike: String = ""
    var minMaxTemparature: String = ""
    var rainPercent: String = ""
    var windDirection: String = ""
    var date: String = ""
}

extension PresentWeather {
    var formatted: WeatherFormatted {
        //Format whole data
        let temparature = "\(Int(self.main?.temparature ?? 0.0)) º"
        var condition = ""
        var description = ""
        var image = ""
        if let weathers = self.weather, weathers.count > 0 {
            condition = weathers[0].main ?? ""
            description = "Humidity \(self.main?.humidity ?? 0)%  \(weathers[0].weatherDescription?.capitalized ?? "")"
            image = weathers[0].icon ?? ""
        }
        let feelsLike = "Feels like \(Int(self.main?.feelsLike ?? 0.0)) º"
        let minMaxTemparature = "Day \(Int(self.main?.tempMax ?? 0.0)) º • Night \(Int(self.main?.tempMin ?? 0.0)) º"
        var rainPercent: Int = 0
        if let the1H = self.rain?.the1H {
            rainPercent = Int(the1H * 100)
        } else if let the3H = self.rain?.the3H {
            rainPercent = Int(the3H * 100)
        } else {
            rainPercent = 0
        }
        let windDirection = self.wind?.deg?.toWindDirection() ?? ""
        let date = self.date?.getDateStringFromUnixTime() ?? ""
        
        // Assign it to model
        var weatherFormatted = WeatherFormatted()
        weatherFormatted.temparature = temparature
        weatherFormatted.condition = condition
        weatherFormatted.description = description
        weatherFormatted.imageURL = "https://openweathermap.org/img/wn/" + image + "@2x.png"
        weatherFormatted.feelsLike = feelsLike
        weatherFormatted.minMaxTemparature = minMaxTemparature
        weatherFormatted.rainPercent = "\(rainPercent)%"
        weatherFormatted.windDirection = windDirection
        weatherFormatted.date = date
        return weatherFormatted
    }

}
