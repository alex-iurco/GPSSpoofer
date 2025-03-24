import Foundation
import Combine

/// ViewModel that manages connection state and provides UI-ready data
class ConnectionViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The current connection state (new model)
    @Published private(set) var connectionState: ConnectionState = .disconnected
    
    /// Whether a device is currently connected
    @Published private(set) var isConnected: Bool = false
    
    /// User-friendly message describing the connection state
    @Published private(set) var connectionMessage: String = "No device connected"
    
    // MARK: - Internal Properties (for transition period)
    
    /// The legacy USB connection state - maintained for backward compatibility
    private(set) var usbConnectionState: USBConnectionState = .disconnected
    
    // MARK: - Private Properties
    
    /// The new connection service protocol implementation
    private let connectionService: ConnectionServiceProtocol?
    
    /// The legacy USB connection service - maintained for backward compatibility
    private let legacyConnectionService: USBConnectionService
    
    /// Cancellable subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Creates a ConnectionViewModel with the new architecture
    /// - Parameter connectionService: The service to use for device connections
    init(connectionService: ConnectionServiceProtocol) {
        self.connectionService = connectionService
        self.legacyConnectionService = USBConnectionService.shared
        setupBindings()
    }
    
    /// Creates a ConnectionViewModel with the legacy service for backward compatibility
    init() {
        self.connectionService = nil
        self.legacyConnectionService = USBConnectionService.shared
        setupLegacyBindings()
    }
    
    // MARK: - Public Methods
    
    /// Attempts to connect to a device
    /// - Returns: True if connection was successful
    func connect() -> Bool {
        if let connectionService = connectionService {
            return connectionService.connect()
        } else {
            // Use the legacy connection service
            return legacyConnectionService.isConnected
        }
    }
    
    /// Disconnects from the currently connected device
    func disconnect() {
        if let connectionService = connectionService {
            connectionService.disconnect()
        }
        // Legacy service doesn't need explicit disconnect as it's managed by the connection manager
    }
    
    /// Checks if a device is available for connection
    /// - Returns: True if a device is available
    func isDeviceAvailable() -> Bool {
        if let connectionService = connectionService {
            return connectionService.isDeviceAvailable()
        } else {
            // In the legacy system, we don't have a separate device availability check
            return legacyConnectionService.isConnected
        }
    }
    
    // MARK: - Private Methods
    
    /// Sets up bindings to the new connection service
    private func setupBindings() {
        guard let connectionService = connectionService else { return }
        
        connectionService.connectionStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateState(state)
            }
            .store(in: &cancellables)
    }
    
    /// Sets up bindings to the legacy connection service
    private func setupLegacyBindings() {
        legacyConnectionService.$connectionState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateLegacyState(state)
            }
            .store(in: &cancellables)
    }
    
    /// Updates the view model state based on the new connection state
    /// - Parameter state: The new connection state
    private func updateState(_ state: USBConnectionState) {
        usbConnectionState = state
        connectionState = ConnectionState.from(usbState: state)
        updateCommonState()
    }
    
    /// Updates the view model state based on the legacy connection state
    /// - Parameter state: The legacy connection state
    private func updateLegacyState(_ state: USBConnectionState) {
        usbConnectionState = state
        connectionState = ConnectionState.from(usbState: state)
        updateCommonState()
    }
    
    /// Updates the common state properties based on the current connection state
    private func updateCommonState() {
        isConnected = connectionState.isConnected
        
        switch connectionState {
        case .connected:
            connectionMessage = "Connected to USB device"
        case .connecting:
            connectionMessage = "Connecting to device..."
        case .disconnected:
            connectionMessage = "No device connected"
        case .error(let message):
            connectionMessage = "Connection error: \(message)"
        }
    }
}
