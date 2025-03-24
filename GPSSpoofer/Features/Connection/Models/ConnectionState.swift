import Foundation

/// Represents the connection state for any type of device connection
enum ConnectionState: Equatable {
    /// Device is connected
    case connected
    /// No device is connected
    case disconnected
    /// Connection in progress
    case connecting
    /// Error occurred during connection attempt
    case error(String)
    
    /// Whether the connection is established
    var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
    
    /// Whether the connection is in progress
    var isConnecting: Bool {
        if case .connecting = self {
            return true
        }
        return false
    }
    
    /// Whether there is an error with the connection
    var hasError: Bool {
        if case .error(_) = self {
            return true
        }
        return false
    }
    
    /// Returns the error message if there is one
    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
    
    /// Converts from the legacy USBConnectionState
    static func from(usbState: USBConnectionState) -> ConnectionState {
        switch usbState {
        case .connected:
            return .connected
        case .disconnected:
            return .disconnected
        case .error(let message):
            return .error(message)
        }
    }
}
