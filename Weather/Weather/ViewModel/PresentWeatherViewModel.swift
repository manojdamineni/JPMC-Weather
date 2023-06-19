//
//  PresentWeatherViewModel.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import Foundation

class PresentWeatherViewModel: ObservableObject {
    
    // MARK: - Properties
    private var city = Observable<String>("")
    private var dataManager: Fetchable
    var isLoading = Observable<Bool>(false)
    var error = Observable<NetworkError?>(nil)
    private var weather = Observable<PresentWeather?>(nil)
    var weatherFormatted = Observable<WeatherFormatted?>(nil)

    // MARK: - Init
    init(dataManager: Fetchable = DataManager()) {
        self.dataManager = dataManager
    }
    
    // MARK: - Updates
    func updateCity(_ city: String) {
        self.city.value = city
    }
}

//MARK: - Networking
extension PresentWeatherViewModel {
    func fetchWeather() {
        //Create request
        var request = PresentWeatherRequest()
        request.parameters = [.query: city.value]
        
        //Send data to server
        isLoading.value = true
        dataManager.fetchData(with: request) { (weather: PresentWeather?, error: NetworkError?) in
            self.isLoading.value = false
            if let weather = weather {
                if let message = weather.message {
                    self.error.value = NetworkError.genericError(message)
                }
                self.weather.value = weather
                self.weatherFormatted.value = weather.formatted
            } else if let error = error {
                self.error.value = error
            }
        }
    }
}

private struct PresentWeatherRequest: APIRequest {
    var method: HTTPMethod = .GET
    var path: EndPoint = .todayForecast
    var parameters: [EndPoint : String] = [:]
    var body: [String : Any]? = nil
}
