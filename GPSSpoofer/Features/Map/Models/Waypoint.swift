import Foundation
import CoreLocation

/// Represents a single waypoint on the map
struct Waypoint: Identifiable, Equatable {
    /// Unique identifier for the waypoint
    let id: UUID
    
    /// Name or description of the waypoint
    var name: String
    
    /// Latitude of the waypoint in degrees
    var latitude: Double
    
    /// Longitude of the waypoint in degrees
    var longitude: Double
    
    /// Optional altitude of the waypoint in meters
    var altitude: Double?
    
    /// Optional speed at this waypoint in meters per second
    var speed: Double?
    
    /// Optional timestamp for when this waypoint should be reached
    var timestamp: Date?
    
    /// Initializes a new waypoint with the specified parameters
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name or description of the waypoint
    ///   - latitude: Latitude in degrees
    ///   - longitude: Longitude in degrees
    ///   - altitude: Optional altitude in meters
    ///   - speed: Optional speed in meters per second
    ///   - timestamp: Optional timestamp
    init(
        id: UUID = UUID(),
        name: String = "Waypoint",
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil,
        speed: Double? = nil,
        timestamp: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speed = speed
        self.timestamp = timestamp
    }
    
    /// Creates a waypoint from a CLLocationCoordinate2D
    /// - Parameters:
    ///   - coordinate: The coordinate to use
    ///   - name: Name or description of the waypoint
    /// - Returns: A new waypoint
    static func from(coordinate: CLLocationCoordinate2D, name: String = "Waypoint") -> Waypoint {
        Waypoint(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// Returns the coordinate representation of this waypoint
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Returns a CLLocation representation of this waypoint
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude ?? 0,
            horizontalAccuracy: 10, // Default accuracy
            verticalAccuracy: altitude != nil ? 10 : -1,
            timestamp: timestamp ?? Date()
        )
    }
    
    /// Calculates the distance to another waypoint in meters
    /// - Parameter other: The other waypoint
    /// - Returns: Distance in meters
    func distance(to other: Waypoint) -> CLLocationDistance {
        return location.distance(from: other.location)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Waypoint, rhs: Waypoint) -> Bool {
        return lhs.id == rhs.id
    }
}
