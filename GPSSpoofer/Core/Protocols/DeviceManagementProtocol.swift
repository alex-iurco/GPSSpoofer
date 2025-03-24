import Foundation
import Combine

/// Defines the interface for device management
protocol DeviceManagementProtocol: ObservableObject {
    /// Whether a device is currently connected
    var isConnected: Bool { get }
    
    /// Any error that occurred during device operations
    var error: Error? { get }
    
    /// Starts the device discovery process
    /// - Returns: True if the device was discovered successfully, false otherwise
    func startDeviceDiscovery() -> Bool
    
    /// Disconnects from the currently connected device
    func disconnect()
    
    /// Sends GPS data to the connected device
    /// - Parameter location: The location to send
    /// - Returns: True if the data was sent successfully, false otherwise
    func sendGPSData(location: Location) -> Bool
}
