import SwiftUI

struct AppTabBarView: View {
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem = .home
    @StateObject private var weatherManager = WeatherManager()
    @StateObject private var locationDataManager = LocationDataManager()
        @State private var showAddView = false
        @State var newModel: ItemModel?
        @State private var locationDeniedAlertShow = false

    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection, tapToPluse: $showAddView) {
            AddView(viewModel: AddViewModel(), newModel: $newModel) { type, item in
                Task {
                    UserDefaults.standard.set(item.latitude, forKey: "latitude")
                    UserDefaults.standard.set(item.longitude, forKey: "longitude")
                    UserDefaults.standard.synchronize()
                    await weatherManager.fetchWeather(lat: item.latitude, long: item.longitude)
                    tabSelection = .location
                    if type == .add {
                        newModel =  ItemModel(
                            timeStamp: Date(),
                            title: weatherManager.currentWeather?.name ?? "",
                            desc: weatherManager.currentWeather?.weather.first??.main ?? "",
                            temp: weatherManager.currentWeather?.main?.temp ?? 0,
                            minTemp: weatherManager.currentWeather?.main?.tempMin ?? 0,
                            maxTemp: weatherManager.currentWeather?.main?.tempMax ?? 0,
                            lat: item.latitude,
                            long: item.longitude,
                            timezone: weatherManager.currentWeather?.timezone ?? 0
                        )
                    }
                }
            }
            .modelContainer(for: ItemModel.self)
            .tabBarItem(tab: .home, selection: $tabSelection)
            .tag(0)
            
            LocationUIView(tabSelection: $tabSelection, weatherManager: weatherManager)
                .tabBarItem(tab: .location, selection: $tabSelection)
                .tag(1)
            
        }
        .onChange(of: locationDataManager.authorizationStatus) { _ in
                    switch locationDataManager.authorizationStatus {
                    case .restricted, .denied:
                        locationDeniedAlertShow = true
                    case .authorizedAlways, .authorizedWhenInUse, .authorized:
                        Task {
                            await weatherManager.fetchWeather()
                        }
                    default:
                        break
                    }
                }
        .modelContainer(for: ItemModel.self)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .sheet(isPresented: $showAddView) {
            SearchUIView(viewModel: AddViewModel()){ type, item in
                Task {
                    UserDefaults.standard.set(item.latitude, forKey: "latitude")
                    UserDefaults.standard.set(item.longitude, forKey: "longitude")
                    UserDefaults.standard.synchronize()
                    await weatherManager.fetchWeather(lat: item.latitude, long: item.longitude)
                    tabSelection = .location
                    if type == .add {
                        newModel =  ItemModel(
                            timeStamp: Date(),
                            title: weatherManager.currentWeather?.name ?? "",
                            desc: weatherManager.currentWeather?.weather.first??.main ?? "",
                            temp: weatherManager.currentWeather?.main?.temp ?? 0,
                            minTemp: weatherManager.currentWeather?.main?.tempMin ?? 0,
                            maxTemp: weatherManager.currentWeather?.main?.tempMax ?? 0,
                            lat: item.latitude,
                            long: item.longitude,
                            timezone: weatherManager.currentWeather?.timezone ?? 0
                        )
                    }
                }
            }
        }
        .alert("Location Permission is Denied", isPresented: $locationDeniedAlertShow) {
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Dismiss", role: .cancel) { }
        }
        .alert(isPresented: $weatherManager.showAlertForError) {
            Alert(title: Text("Error"), message: Text(weatherManager.alertMessage), dismissButton: .default(Text("OK")))
        }
        
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    
    static var previews: some View {
        AppTabBarView()
    }
}
