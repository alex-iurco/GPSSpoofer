import Foundation

enum DeviceType {
    case usb
}

struct Device: Identifiable {
    let id: UUID
    let type: DeviceType
    let name: String
    let isConnected: Bool
    
    init(id: UUID = UUID(), type: DeviceType, name: String, isConnected: Bool = false) {
        self.id = id
        self.type = type
        self.name = name
        self.isConnected = isConnected
    }
} 