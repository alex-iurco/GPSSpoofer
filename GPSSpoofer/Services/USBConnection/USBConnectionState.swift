import Foundation

/// Represents the possible states of a USB connection
enum USBConnectionState: Equatable {
    /// Device is connected via USB
    case connected
    /// No device is connected
    case disconnected
    /// Error occurred during connection attempt
    case error(String)
    
    var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
}
