import Foundation

struct Location: Codable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let timestamp: Date
    
    init(latitude: Double, longitude: Double, altitude: Double, timestamp: Date = Date()) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.timestamp = timestamp
    }
    
    var isValid: Bool {
        latitude >= -90 && latitude <= 90 &&
        longitude >= -180 && longitude <= 180 &&
        altitude >= -1000 && altitude <= 100000 // Reasonable altitude range
    }
} 