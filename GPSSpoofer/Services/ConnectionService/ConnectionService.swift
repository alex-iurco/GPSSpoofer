import Foundation
import Combine

class ConnectionService: ObservableObject {
    @Published var isConnected = false
    @Published var error: Error?
    
    private let deviceManager = DeviceManager()
    private var cancellables = Set<AnyCancellable>()
    
    func connect() {
        if deviceManager.startDeviceDiscovery() {
            isConnected = true
        } else {
            error = DeviceError.connectionFailed
            isConnected = false
        }
    }
    
    func disconnect() {
        deviceManager.disconnect()
        isConnected = false
    }
} 