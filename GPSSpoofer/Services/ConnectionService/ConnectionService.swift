import Foundation
import Combine

class ConnectionService: ObservableObject {
    @Published var isConnected = false
    @Published var error: Error?
    
    private let deviceManager = DeviceManager()
    private var cancellables = Set<AnyCancellable>()
    
    func connect() {
        isConnected = deviceManager.startDeviceDiscovery()
    }
    
    func disconnect() {
        deviceManager.disconnect()
        isConnected = false
    }
} 