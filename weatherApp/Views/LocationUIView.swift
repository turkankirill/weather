import SwiftUI
import SwiftData
struct LocationUIView: View {
    @Binding var tabSelection: TabBarItem
    @ObservedObject var weatherManager: WeatherManager
    @StateObject private var locationDataManager = LocationDataManager()
    @Environment(\.modelContext) private var context
        @Query private var items: [ItemModel]
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SubView(currentWeather: $weatherManager.currentWeather)
                HourlyListView(forecastWeather: $weatherManager.forecastWeather, currentWeather: $weatherManager.currentWeather)
                DailyListView(forecastWeather: $weatherManager.forecastWeather)
                DataListView(currentWeather: $weatherManager.currentWeather)
            }
        }
        .background {
            LinearGradient(colors: /*weatherManager.currentWeather?.weather.first??.main == "Clear" ? [Color.bgSun1, Color.bgSun2] :*/ [Color.bg1, Color.bg2], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        }
        .onChange(of: locationDataManager.authorizationStatus) { _ in
            switch locationDataManager.authorizationStatus {
            case .restricted, .denied:
                locationDataManager.locationDeniedAlertShow = true
            case .authorizedAlways, .authorizedWhenInUse, .authorized:
                Task {
                    await weatherManager.fetchWeather()
                    updateOrCreateItem()
                }
            default:
                break
            }
        }
        .alert(isPresented: $weatherManager.showAlertForError) {
            Alert(title: Text("Error"), message: Text(weatherManager.alertMessage), dismissButton: .default(Text("OK")))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "heart")
                    .onTapGesture {
                        addToFavorite()
                        tabSelection = .home
                        
                    }
                
            }
        }
        
    }
    private func updateOrCreateItem() {
           if items.isEmpty {
               guard let currentWeather = weatherManager.currentWeather else { return }
               let newItem = ItemModel(
                   timeStamp: Date(),
                   title: currentWeather.name ?? "Unknown Location",
                   desc: currentWeather.weather.first??.main ?? "No Data",
                   temp: currentWeather.main?.temp ?? 0,
                   minTemp: currentWeather.main?.tempMin ?? 0,
                   maxTemp: currentWeather.main?.tempMax ?? 0,
                   lat: currentWeather.coord?.lat ?? 0,
                   long: currentWeather.coord?.lon ?? 0,
                   timezone: 0 
               )
               context.insert(newItem)
               try? context.save()
           } else {
               if var firstItem = items.first {
                   let coordinates = (firstItem.lat, firstItem.long)
                   Task {
                       do {
                           let currentWeather: CurrentDataModel = try await APIService.shared.fetchData(endpoint: .currentWeatherData(latitude: coordinates.0, longitude: coordinates.1))
                           firstItem.timestamp = Date()
                           firstItem.title = currentWeather.name ?? ""
                           firstItem.desc = currentWeather.weather.first??.main ?? ""
                           firstItem.temp = currentWeather.main?.temp ?? 0
                           firstItem.minTemp = currentWeather.main?.tempMin ?? 0
                           firstItem.maxTemp = currentWeather.main?.tempMax ?? 0
                           try? context.save()
                       } catch {
                           print("Error: \(error)")
                       }
                   }
               }
           }
       }
    private func addToFavorite() {
               guard let currentWeather = weatherManager.currentWeather else { return }
               let newItem = ItemModel(
                   timeStamp: Date(),
                   title: currentWeather.name ?? "Unknown Location",
                   desc: currentWeather.weather.first??.main ?? "No Data",
                   temp: currentWeather.main?.temp ?? 0,
                   minTemp: currentWeather.main?.tempMin ?? 0,
                   maxTemp: currentWeather.main?.tempMax ?? 0,
                   lat: currentWeather.coord?.lat ?? 0,
                   long: currentWeather.coord?.lon ?? 0,
                   timezone: 0
               )
               context.insert(newItem)
               try? context.save()
           
       }
}

