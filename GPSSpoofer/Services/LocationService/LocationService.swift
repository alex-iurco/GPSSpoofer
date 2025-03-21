import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var spoofedLocation: CLLocation?
    @Published var isUpdatingLocation = false
    
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        default:
            print("Location services are not authorized")
        }
    }
    
    func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
        isUpdatingLocation = false
    }
    
    func setSpoofedLocation(latitude: Double, longitude: Double) {
        spoofedLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Location services authorized")
            startUpdatingLocation()
        default:
            print("Location services not authorized")
            stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed: \(error.localizedDescription)")
        stopUpdatingLocation()
    }
} 