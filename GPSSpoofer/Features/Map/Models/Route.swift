import Foundation
import CoreLocation

/// Represents a route of ordered waypoints
struct Route: Identifiable, Equatable {
    /// Unique identifier for the route
    let id: UUID
    
    /// Name of the route
    var name: String
    
    /// Ordered collection of waypoints that make up the route
    var waypoints: [Waypoint]
    
    /// Whether this route is currently being simulated
    var isActive: Bool = false
    
    /// Initializes a new route with the specified parameters
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name of the route
    ///   - waypoints: Collection of waypoints
    ///   - isActive: Whether the route is active
    init(
        id: UUID = UUID(),
        name: String = "New Route",
        waypoints: [Waypoint] = [],
        isActive: Bool = false
    ) {
        self.id = id
        self.name = name
        self.waypoints = waypoints
        self.isActive = isActive
    }
    
    /// Calculates the total distance of the route in meters
    var totalDistance: CLLocationDistance {
        guard waypoints.count > 1 else { return 0 }
        
        var distance: CLLocationDistance = 0
        for i in 0..<(waypoints.count - 1) {
            distance += waypoints[i].distance(to: waypoints[i + 1])
        }
        
        return distance
    }
    
    /// Calculates the estimated duration of the route in seconds based on waypoint speeds
    var estimatedDuration: TimeInterval {
        guard waypoints.count > 1 else { return 0 }
        
        // If we have timestamps on all waypoints, use those
        if let firstTime = waypoints.first?.timestamp,
           let lastTime = waypoints.last?.timestamp {
            return lastTime.timeIntervalSince(firstTime)
        }
        
        // Otherwise estimate based on distances and speeds
        var duration: TimeInterval = 0
        for i in 0..<(waypoints.count - 1) {
            let distance = waypoints[i].distance(to: waypoints[i + 1])
            
            // Get speed (either from waypoint or default to walking speed of 1.4 m/s)
            let speed = waypoints[i].speed ?? 1.4
            
            // Calculate time for this segment
            duration += TimeInterval(distance / speed)
        }
        
        return duration
    }
    
    /// Creates a copy of this route with a new ID
    /// - Returns: A new Route with the same properties but a different ID
    func duplicate() -> Route {
        return Route(
            name: "\(name) Copy",
            waypoints: waypoints,
            isActive: false
        )
    }
    
    /// Adds a waypoint to the route
    /// - Parameter waypoint: The waypoint to add
    /// - Returns: A new route with the added waypoint
    func adding(_ waypoint: Waypoint) -> Route {
        var newWaypoints = waypoints
        newWaypoints.append(waypoint)
        return Route(
            id: id,
            name: name,
            waypoints: newWaypoints,
            isActive: isActive
        )
    }
    
    /// Removes a waypoint from the route
    /// - Parameter id: The ID of the waypoint to remove
    /// - Returns: A new route without the specified waypoint
    func removing(waypointWithId id: UUID) -> Route {
        let filteredWaypoints = waypoints.filter { $0.id != id }
        return Route(
            id: self.id,
            name: name,
            waypoints: filteredWaypoints,
            isActive: isActive
        )
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.id == rhs.id
    }
}
