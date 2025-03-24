import Foundation
import Combine

class ConnectionService: ObservableObject {
    @Published var isConnected = false
    @Published var error: Error?
    
    private let deviceManager = DeviceManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to device manager connection status
        deviceManager.$isConnected
            .sink { [weak self] connected in
                self?.isConnected = connected
            }
            .store(in: &cancellables)
    }
    
    func connect() {
        isConnected = deviceManager.startDeviceDiscovery()
    }
    
    func disconnect() {
        deviceManager.disconnect()
        isConnected = false
    }
} 