import Foundation
import CoreLocation

class Waypoint: Identifiable, Codable {
    let id: UUID
    var coordinate: CLLocationCoordinate2D
    var altitude: Double?
    
    init(id: UUID = UUID(), coordinate: CLLocationCoordinate2D, altitude: Double? = nil) {
        self.id = id
        self.coordinate = coordinate
        self.altitude = altitude
    }
    
    // For Codable conformance
    private enum CodingKeys: String, CodingKey {
        case id, latitude, longitude, altitude
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        altitude = try container.decodeIfPresent(Double.self, forKey: .altitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
        try container.encodeIfPresent(altitude, forKey: .altitude)
    }
} 