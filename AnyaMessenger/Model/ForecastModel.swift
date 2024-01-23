//
//  ForecastModel.swift
//  AnyaMessenger
//
//  Created by chiamakabrowneyes on 1/10/24.
//

import Foundation

enum ForecastPeriod {
    case hourly
    case daily
}

enum Weather: String {
    case clear = "Clear"
    case cloudy = "Cloudy"
    case rainy = "Mid Rain"
    case stormy = "Showers"
    case sunny = "Sunny"
    case tornado = "Tornado"
    case windy = "Fast Wind"
}

struct Forecast: Identifiable {
    var id = UUID()
    var reportText: String
    var location: String
}

extension Forecast {
    
    static let cities: [Forecast] = [
        Forecast(reportText: "I was just walking down the street when I heard this huge bang. I turned around and saw a red car had smashed into a streetlight.", location: "Montreal, Canada"),
        Forecast(reportText: "My friend just sirened me that theres a gang robbery around the filling station at Abeokuta junction. Be safe y'all", location: "Toronto, Canada"),
        Forecast(reportText: "Heads up, I just got a text about a major accident on Main Street near the library. Better take a different route if you're heading that way.", location: "Tokyo, Japan"),
        Forecast(reportText: "There's a wildfire spreading near the Pine Ridge area. If you're nearby, stay alert and be ready to evacuate if needed. Stay safe!", location: "Tennessee, United States"),
        Forecast(reportText: "There's been a chemical spill reported at the factory on 5th Avenue. Authorities are advising everyone in the area to stay indoors", location: "Tennessee, United States"),
        Forecast(reportText: "Guys, be extra careful if you're going downtown. There's a large protest turning violent near City Hall. It's best to avoid the area entirely tonight.", location: "Tennessee, United States")
    ]
}
