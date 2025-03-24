import Foundation
import CoreLocation

/// Represents a geographic location
struct Location: Identifiable, Equatable {
    /// Unique identifier for the location
    let id: UUID
    
    /// Name or description of the location
    var name: String
    
    /// Latitude in degrees
    var latitude: Double
    
    /// Longitude in degrees
    var longitude: Double
    
    /// Optional altitude in meters
    var altitude: Double?
    
    /// Initializes a new location with the specified parameters
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: Name or description of the location
    ///   - latitude: Latitude in degrees
    ///   - longitude: Longitude in degrees
    ///   - altitude: Optional altitude in meters
    init(
        id: UUID = UUID(),
        name: String = "Location",
        latitude: Double,
        longitude: Double,
        altitude: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }
    
    /// Creates a location from a CLLocationCoordinate2D
    /// - Parameters:
    ///   - coordinate: The coordinate to use
    ///   - name: Name or description of the location
    /// - Returns: A new location
    static func from(coordinate: CLLocationCoordinate2D, name: String = "Location") -> Location {
        Location(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// Returns the coordinate representation of this location
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Returns a CLLocation representation of this location
    var clLocation: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude ?? 0,
            horizontalAccuracy: 10, // Default accuracy
            verticalAccuracy: altitude != nil ? 10 : -1,
            timestamp: Date()
        )
    }
    
    /// Calculates the distance to another location in meters
    /// - Parameter other: The other location
    /// - Returns: Distance in meters
    func distance(to other: Location) -> CLLocationDistance {
        return clLocation.distance(from: other.clLocation)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}
