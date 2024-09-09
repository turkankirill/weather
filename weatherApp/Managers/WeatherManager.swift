import Foundation

class WeatherManager: ObservableObject {
    @Published var currentWeather: CurrentDataModel?
    @Published var forecastWeather: ForecastModelData?
    @Published var showAlertForError = false
    @Published var alertMessage = ""

    func fetchWeather(lat: Double? = nil, long: Double? = nil) async {
        guard let coordinate = determineCoordinate(lat: lat, long: long) else {
            print("Error: Coordinate is nil")
            return
        }
        do {
            let (currentWeather, forecastWeather) = try await fetchCurrentAndForecastWeather(coordinate: coordinate)
            await MainActor.run {
                self.currentWeather = currentWeather
                self.forecastWeather = forecastWeather
                self.showAlertForError = false
            }
        } catch let error as AppError {
            await MainActor.run {
                self.showAlertForError = true
                self.alertMessage = error.errorMessage
            }
            print("Error: \(error.errorMessage)")
        } catch {
            await MainActor.run {
                self.showAlertForError = true
                self.alertMessage = "An unknown error occurred."
            }
        }
    }

    private func determineCoordinate(lat: Double?, long: Double?) -> (Double, Double)? {
        if let lat, let long {
            return (lat, long)
        } else if let lat = UserDefaults.standard.object(forKey: "latitude") as? Double, let long = UserDefaults.standard.object(forKey: "longitude") as? Double {
            return (lat, long)
        } else if let location = LocationDataManager().locationManager.location {
            return (location.coordinate.latitude, location.coordinate.longitude)
        }
        return nil
    }

    private func fetchCurrentAndForecastWeather(coordinate: (Double, Double)) async throws -> (CurrentDataModel?, ForecastModelData?) {
        return try await withThrowingTaskGroup(of: (CurrentDataModel?, ForecastModelData?).self) { group in
            group.addTask {
                let weather: CurrentDataModel? = try await APIService.shared.fetchData(endpoint: .currentWeatherData(latitude: coordinate.0, longitude: coordinate.1))
                return (weather, nil)
            }
            group.addTask {
                let forecast: ForecastModelData? = try await APIService.shared.fetchData(endpoint: .forecastWeatherData(latitude: coordinate.0, longitude: coordinate.1))
                return (nil, forecast)
            }

            var weather: CurrentDataModel?
            var forecast: ForecastModelData?

            for try await (currentItem, forecastItem) in group {
                if let currentWeather = currentItem {
                    weather = currentWeather
                }
                if let forecastWeather = forecastItem {
                    forecast = forecastWeather
                }
            }

            return (weather, forecast)
        }
    }
}
