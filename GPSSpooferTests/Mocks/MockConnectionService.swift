import Foundation
import Combine
@testable import GPSSpoofer

/// A mock implementation of ConnectionServiceProtocol for testing
class MockConnectionService: ConnectionServiceProtocol {
    /// The current state of the device connection
    @Published private(set) var connectionState: USBConnectionState
    
    /// A publisher that emits the current connection state
    var connectionStatePublisher: AnyPublisher<USBConnectionState, Never> {
        $connectionState.eraseToAnyPublisher()
    }
    
    /// Tracks the number of times connect() was called
    private(set) var connectCallCount = 0
    
    /// Tracks the number of times disconnect() was called
    private(set) var disconnectCallCount = 0
    
    /// Tracks the number of times isDeviceAvailable() was called
    private(set) var isDeviceAvailableCallCount = 0
    
    /// Value to return from connect()
    var connectReturnValue = true
    
    /// Value to return from isDeviceAvailable()
    var isDeviceAvailableReturnValue = true
    
    /// Initializes the mock with a specified initial state
    /// - Parameter initialState: The initial connection state
    init(initialState: USBConnectionState = .disconnected) {
        self.connectionState = initialState
    }
    
    /// Sets the connection state to a new value
    /// - Parameter newState: The new connection state
    func setConnectionState(_ newState: USBConnectionState) {
        connectionState = newState
    }
    
    // MARK: - ConnectionServiceProtocol Methods
    
    /// Attempts to connect to a device
    /// - Returns: True if connection was successful, false otherwise
    func connect() -> Bool {
        connectCallCount += 1
        
        // If connect should succeed, update the state to connected
        if connectReturnValue {
            connectionState = .connected
        }
        
        return connectReturnValue
    }
    
    /// Disconnects from the currently connected device
    func disconnect() {
        disconnectCallCount += 1
        connectionState = .disconnected
    }
    
    /// Checks if a device is available for connection
    /// - Returns: True if a device is available, false otherwise
    func isDeviceAvailable() -> Bool {
        isDeviceAvailableCallCount += 1
        return isDeviceAvailableReturnValue
    }
} 