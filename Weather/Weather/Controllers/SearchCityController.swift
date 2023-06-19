//
//  SearchCityController.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import UIKit
import SwiftUI
import CoreLocation

class SearchCityController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchLocationLabel: UILabel!
    @IBOutlet weak var searchLocationWeatherView: UIView!
    @IBOutlet weak var currentLocationWeatherView: UIView!
    @IBOutlet weak var currentLocationContainerWeatherView: UIView!
    @IBOutlet weak var searchLocationContainerWeatherView: UIView!
    
    // MARK: - Properties
    var viewModel = PresentWeatherViewModel()
    let locationManager = CLLocationManager()
    lazy private var searchBar = UISearchBar(frame: .zero)
    lazy private var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.tintColor = UIColor(Color.primary)
        searchController.searchBar.delegate = self
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Search City"
        navigationItem.searchController = searchController
        
        //Request location authentication
        requestLocationServices()

        //Bind data to UI
        bindDataToUI()
    }

    private func requestLocationServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func bindDataToUI() {
        searchLocationLabel.text = ""
        viewModel.isLoading.bind { [unowned self] (isLoading) in
            if isLoading { self.presentActivity() }
            else { self.dismissActivity() }
        }
        
        viewModel.error.bind { [unowned self] (error) in
            self.presentSimpleAlert(title: "Weather",
                                    message: error?.description ?? "")
        }
        
        viewModel.weatherFormatted.bind { [unowned self] (weather) in
            if let weather = weather {
                DispatchQueue.main.async { [self] in
                    if !weather.city.isEmpty {
                        searchLocationLabel.text = "\(weather.city)'s Weather"
                    } else {
                        searchLocationLabel.text = ""
                    }
                    self.setupData(weather, on: searchLocationWeatherView)
                }
            }
        }
        
        viewModel.presentLocationWeatherFormatted.bind { [unowned self] (weather) in
            if let weather = weather {
                DispatchQueue.main.async { [self] in
                    self.setupData(weather, on: currentLocationWeatherView)
                }
            }
        }
        
        viewModel.searchBarEditing.bind { [unowned self] editing in
            DispatchQueue.main.async { [self] in
                currentLocationContainerWeatherView.isHidden = editing
                searchLocationContainerWeatherView.isHidden = editing
            }
        }
    }
    
    private func setupData(_ weather: WeatherFormatted, on view: UIView) {
        let weatherView = PresentWeatherView(weather: weather)
        if let rootView = UIHostingController(rootView: weatherView).view {
            view.subviews.forEach { $0.removeFromSuperview() }
            view.addSubview(rootView)
            rootView.translatesAutoresizingMaskIntoConstraints = false
            view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: rootView.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: rootView.bottomAnchor).isActive = true
        }
    }

    //MARK: - API
    private func fetchWeather() {
        viewModel.fetchWeather()
    }
}

// MARK: - UISearchController Delegate
extension SearchCityController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        viewModel.updateSearchEditing(true)
        return true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.updateSearchEditing(false)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateCity(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.updateCity("")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchWeather()
    }
}

//MARK: - Spinner
extension SearchCityController: ActivityPresentable {}

//MARK: - CLLocationManagerDelegate
extension SearchCityController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted, .notDetermined:
            self.presentSimpleAlert(title: "Weather", message: "Location services are disabled. Please go to Settings to enable.")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            viewModel.updateUserLocation(location)
            locationManager.stopUpdatingLocation()
        }
    }
}
