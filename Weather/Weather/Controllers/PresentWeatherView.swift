//
//  PresentWeatherView.swift
//  Weather
//
//  Created by MM on 6/18/23.
//

import SwiftUI

struct PresentWeatherView: View {
    var weather: WeatherFormatted

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text(weather.temparature)
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                    Text(weather.condition)
                        .font(.system(size: 17, design: .rounded))
                }
                Spacer()
                AsyncImage(url: URL(string: weather.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.white
                }
                .frame(width: 60, height: 90)
            }
            HStack {
                VStack(alignment: .leading, spacing: 24.0) {
                    Text(weather.feelsLike)
                        .font(.system(size: 17, design: .rounded))
                    Text(weather.minMaxTemparature)
                        .font(.system(size: 17, design: .rounded))
                }
                Spacer()
                VStack {
                    HStack {
                        Image("icon-rain")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.rainPercent)
                            .font(.system(size: 17, design: .rounded))
                    }
                    HStack {
                        Image("icon-wind")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text(weather.windDirection)
                            .font(.system(size: 17, design: .rounded))
                    }
                }
            }
        }
        .padding(.horizontal, 20.0)
    }
}

struct PresentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        let weather: PresentWeather = FileLoader.readDataFromFile(at: "weather_data")
        PresentWeatherView(weather: weather.formatted)
    }
}
