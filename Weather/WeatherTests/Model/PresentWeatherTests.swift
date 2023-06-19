//
//  PresentWeatherTests.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import XCTest

class PresentWeatherTests: XCTestCase {
    
    //MARK: - Variables
    var weather: PresentWeather!
    
    //MARK: - Setup
    override func setUp() {
        super.setUp()
    }

    //MARK: - Tests
    func testWeatherModel() {
        let weather: PresentWeather = FileLoader.readDataFromFile(at: "weather_data")
        XCTAssertNotNil(weather, "Weather should not be nil.")
        XCTAssertEqual(weather.weather?[0].id, 801, "Weather ids should be equal.")
        XCTAssertEqual(weather.wind?.deg, 90, "Weather wind degrees should be equal.")
        XCTAssertEqual(weather.main?.temparature, 12.32, "Weather temp.s should be equal.")
    }

    //MARK: - Tear down
    override func tearDown() {
        super.tearDown()
    }
}
