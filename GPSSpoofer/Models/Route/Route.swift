import Foundation
import CoreLocation

enum MovementType: String, Codable {
    case walking
    case running
    case cycling
    case driving
}

class Route: Identifiable, Codable {
    let id: UUID
    var name: String
    var waypoints: [Waypoint]
    var movementType: MovementType
    var creationDate: Date
    
    init(id: UUID = UUID(), name: String, waypoints: [Waypoint] = [], movementType: MovementType = .walking) {
        self.id = id
        self.name = name
        self.waypoints = waypoints
        self.movementType = movementType
        self.creationDate = Date()
    }
} 