import Foundation
import SwiftUI
import CoreLocation
import Combine

/// A service provider that manages dependencies throughout the application
class ServiceProvider {
    // MARK: - Singleton
    
    /// The shared instance of the service provider
    static let shared = ServiceProvider()
    
    // MARK: - Services
    
    /// The connection service
    private(set) lazy var connectionService: ConnectionServiceProtocol = {
        return USBConnectionServiceImpl()
    }()
    
    /// The device management service
    private(set) lazy var deviceManager: DeviceManagementProtocol = {
        // In the future, this would be a proper implementation of DeviceManagementProtocol
        // For now, we'll continue to use the existing DeviceManager
        return DeviceManager()
    }()
    
    /// The location service
    private(set) lazy var locationService: LocationServiceProtocol = {
        return LegacyLocationServiceAdapter()
    }()
    
    // MARK: - ViewModels
    
    /// Creates a new connection view model
    func makeConnectionViewModel() -> ConnectionViewModel {
        return ConnectionViewModel(connectionService: connectionService)
    }
    
    /// Creates a new map view model
    func makeMapViewModel() -> MapViewModel {
        return MapViewModel(locationService: locationService)
    }
    
    // MARK: - Private Initialization
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Testing Support
    
    /// For testing only - replaces the connection service with a mock
    /// - Parameter service: The mock service to use
    func setConnectionService(_ service: ConnectionServiceProtocol) {
        _connectionService = service
    }
    
    /// For testing only - replaces the device manager with a mock
    /// - Parameter manager: The mock manager to use
    func setDeviceManager(_ manager: DeviceManagementProtocol) {
        _deviceManager = manager
    }
    
    /// For testing only - replaces the location service with a mock
    /// - Parameter service: The mock service to use
    func setLocationService(_ service: LocationServiceProtocol) {
        _locationService = service
    }
    
    // MARK: - Private Properties for Testing
    
    /// Backing storage for the connection service
    private var _connectionService: ConnectionServiceProtocol?
    
    /// Backing storage for the device manager
    private var _deviceManager: DeviceManagementProtocol?
    
    /// Backing storage for the location service
    private var _locationService: LocationServiceProtocol?
}
