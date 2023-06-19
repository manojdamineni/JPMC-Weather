//
//  SearchCityController.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import Foundation

import UIKit
import SwiftUI

class SearchCityController: UIViewController {

    // MARK: - Properties
    var viewModel = PresentWeatherViewModel()
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
        
        //Bind data to UI
        bindDataToUI()
    }
    
    private func bindDataToUI() {
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
                DispatchQueue.main.async {
                    self.setupData(weather)
                }
            }
        }
    }
    
    private func setupData(_ weather: WeatherFormatted) {
        let weatherView = PresentWeatherView(weather: weather)
        if let rootView = UIHostingController(rootView: weatherView).view {
            self.view.addSubview(rootView)
            rootView.translatesAutoresizingMaskIntoConstraints = false
            self.view.leadingAnchor.constraint(equalTo: rootView.leadingAnchor).isActive = true
            self.view.trailingAnchor.constraint(equalTo: rootView.trailingAnchor).isActive = true
            self.view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor).isActive = true
            rootView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        }
    }

    //MARK: - API
    private func fetchWeather() {
        viewModel.fetchWeather()
    }
}

// MARK: - UISearchController Delegate
extension SearchCityController: UISearchBarDelegate {
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
