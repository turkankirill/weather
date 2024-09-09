
import Foundation

enum Endpoint {
    enum Constant {
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
        static let apiKey = "c7e61dad20aa74e5e23d2f05520748e7"
    }

    case currentWeatherData(latitude: Double, longitude: Double)
    case forecastWeatherData(latitude: Double, longitude: Double)
    
    var url: String {
        switch self {
        case .currentWeatherData(let latitude, let longitude):
            return "\(Constant.baseURL)weather?lat=\(latitude)&lon=\(longitude)&apiKey=\(Constant.apiKey)&units=metric"
        case .forecastWeatherData(let latitude, let longitude):
            return "\(Constant.baseURL)forecast?lat=\(latitude)&lon=\(longitude)&apiKey=\(Constant.apiKey)&units=metric"
        }
    }
}
