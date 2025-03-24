import Foundation
import Combine
import CoreLocation

/// Defines the interface for location services
protocol LocationServiceProtocol: ObservableObject {
    /// The current location
    var currentLocation: Location? { get }
    
    /// Publisher for location updates
    var locationPublisher: AnyPublisher<Location, Never> { get }
    
    /// Sets a new simulated location
    /// - Parameter location: The location to simulate
    func setLocation(_ location: Location)
    
    /// Follows a route with simulated movement
    /// - Parameters:
    ///   - route: The route to follow
    ///   - speed: The speed in meters per second
    ///   - completion: Called when the route is completed
    func followRoute(_ route: Route, speed: Double, completion: @escaping () -> Void)
    
    /// Stops any active route following
    func stopFollowingRoute()
    
    /// The active route being followed, if any
    var activeRoute: Route? { get }
    
    /// Whether a route is currently being followed
    var isFollowingRoute: Bool { get }
}
