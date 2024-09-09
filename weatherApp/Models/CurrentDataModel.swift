
import Foundation


struct WeatherData {
    var currentWeather: CurrentDataModel?
    var forecastWeather: ForecastModelData?
}

struct CurrentDataModel: Decodable {
    let coord: Coordinate?
    let weather: [Weather?]
    let base: String?
    let main: Main?
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int?
    let sys: Sys?
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
}

struct Coordinate: Decodable, Hashable {
    let lon: Double?
    let lat: Double?
}

struct Weather: Decodable, Hashable {
    let main: String?
    let description: String?
    let icon: String?
}

struct Main: Decodable, Hashable {
    let temp: Float?
    let feelsLike: Float?
    let tempMin: Float?
    let tempMax: Float?
    let pressure: Int?
    let humidity: Int?
     
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
}

struct Wind: Decodable, Hashable {
    let speed: Float?
    let deg: Int?
}

struct Clouds: Decodable, Hashable {
    let all: Int?
}

struct Sys: Codable, Hashable {
    let country: String?
    let sunrise: Date?
    let sunset: Date?
}
