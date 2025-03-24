import Foundation
import Combine

/// Implementation of ConnectionServiceProtocol that uses the USB connection manager
class USBConnectionServiceImpl: ConnectionServiceProtocol {
    // MARK: - Published Properties
    
    /// The current state of the USB connection
    @Published private(set) var connectionState: USBConnectionState = .disconnected
    
    // MARK: - Properties
    
    /// Publisher for connection state updates
    var connectionStatePublisher: AnyPublisher<USBConnectionState, Never> {
        $connectionState.eraseToAnyPublisher()
    }
    
    // MARK: - Private Properties
    
    /// The connection manager that handles USB device events
    private let connectionManager = USBConnectionManager()
    
    /// The subscription ID for the connection manager
    private var subscriptionId: UUID?
    
    // MARK: - Initialization
    
    init() {
        setupSubscription()
    }
    
    deinit {
        if let id = subscriptionId {
            connectionManager.unsubscribe(id)
        }
    }
    
    // MARK: - Public Methods
    
    /// Attempts to connect to a device
    /// - Returns: True if connection was successful
    func connect() -> Bool {
        // This could be expanded to include more functionality in the future
        return isConnected
    }
    
    /// Disconnects from the currently connected device
    func disconnect() {
        // Currently we don't need to explicitly disconnect, as the connection
        // manager handles device disconnection automatically
    }
    
    /// Checks if a device is available for connection
    /// - Returns: True if a device is available
    func isDeviceAvailable() -> Bool {
        // For now, just check if we're already connected
        // In a future implementation, this could scan for available devices
        return isConnected
    }
    
    // MARK: - Private Methods
    
    /// Sets up the subscription to the connection manager
    private func setupSubscription() {
        subscriptionId = connectionManager.subscribe { [weak self] state in
            self?.connectionState = state
        }
    }
}
