import Foundation
import CoreLocation
import Combine

/// Adapter that bridges legacy location code to the new LocationServiceProtocol
class LegacyLocationServiceAdapter: LocationServiceProtocol {
    // MARK: - Properties
    
    /// Publisher for the current location
    private let locationSubject = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
    
    /// Publisher for location updates
    var currentLocationPublisher: AnyPublisher<CLLocationCoordinate2D?, Never> {
        return locationSubject.eraseToAnyPublisher()
    }
    
    /// Whether location updates are active
    private(set) var isUpdating = false
    
    // MARK: - Initialization
    
    init() {
        // Any initialization from legacy systems would happen here
    }
    
    // MARK: - LocationServiceProtocol
    
    /// Starts providing location updates
    func startLocationUpdates() {
        isUpdating = true
        
        // In a future implementation, this would integrate with the existing location code
        // For now, we'll just start with a default location (San Francisco)
        let defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        locationSubject.send(defaultLocation)
    }
    
    /// Stops providing location updates
    func stopLocationUpdates() {
        isUpdating = false
    }
    
    /// Sets a specific location to be used
    /// - Parameter coordinate: The coordinate to set
    func setLocation(_ coordinate: CLLocationCoordinate2D) {
        locationSubject.send(coordinate)
    }
}
