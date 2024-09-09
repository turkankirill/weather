import Foundation
import CoreLocation
import SwiftUI
final class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @State var locationDeniedAlertShow = false
    override init() {
        super.init()
        locationManager.delegate = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            authorizationStatus = .authorizedWhenInUse
            locationManager.requestLocation()
            break
        case .restricted:
            authorizationStatus = .restricted
            break
        case .denied:
            authorizationStatus = .denied
            break
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    } 
}
