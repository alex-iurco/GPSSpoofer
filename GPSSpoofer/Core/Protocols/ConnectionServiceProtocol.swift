import Foundation
import Combine

/// Defines the interface for connection services that manage USB device connections
protocol ConnectionServiceProtocol: ObservableObject {
    /// The current state of the device connection
    var connectionState: USBConnectionState { get }
    
    /// A convenience property that returns true if the connection state is .connected
    var isConnected: Bool { get }
    
    /// A publisher that emits the current connection state
    var connectionStatePublisher: AnyPublisher<USBConnectionState, Never> { get }
    
    /// Attempts to connect to a device
    /// - Returns: True if connection was successful, false otherwise
    func connect() -> Bool
    
    /// Disconnects from the currently connected device
    func disconnect()
    
    /// Checks if a device is available for connection
    /// - Returns: True if a device is available, false otherwise
    func isDeviceAvailable() -> Bool
}

// Default implementation for common computed properties
extension ConnectionServiceProtocol {
    var isConnected: Bool {
        if case .connected = connectionState {
            return true
        }
        return false
    }
}
