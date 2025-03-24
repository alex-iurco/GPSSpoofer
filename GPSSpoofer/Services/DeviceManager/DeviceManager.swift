import Foundation
import Combine

class DeviceManager: ObservableObject {
    @Published var isConnected = false
    private var usbDevice: USBDeviceCommunication?
    
    // Connection to the USB connection service
    private var connectionService = USBConnectionService.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        usbDevice = nil
        isConnected = false
        
        // Subscribe to connection state changes
        connectionService.$connectionState
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .connected:
                    // When a device is connected via the USB connection manager,
                    // automatically try to connect to it
                    _ = self.startDeviceDiscovery()
                case .disconnected, .error:
                    // When a device is disconnected, clean up resources
                    self.disconnect()
                }
            }
            .store(in: &cancellables)
    }
    
    func startDeviceDiscovery() -> Bool {
        // Don't try to connect if we're not in the connected state
        guard connectionService.connectionState.isConnected else {
            return false
        }
        
        // Create USB device communication instance
        usbDevice = USBDeviceCommunication()
        
        // Try connecting to the device
        if usbDevice?.connectToDevice(service: 0) == true {
            print("Successfully connected to simulated iOS device")
            isConnected = true
            return true
        }
        
        disconnect()
        return false
    }
    
    func sendLocationUpdate(latitude: Double, longitude: Double, altitude: Double) -> Bool {
        guard let usbDevice = usbDevice, isConnected else {
            print("No USB device connected")
            return false
        }
        
        // Format location data into bytes
        var locationData = Data()
        locationData.append(contentsOf: withUnsafeBytes(of: latitude) { Array($0) })
        locationData.append(contentsOf: withUnsafeBytes(of: longitude) { Array($0) })
        locationData.append(contentsOf: withUnsafeBytes(of: altitude) { Array($0) })
        
        return usbDevice.sendLocationData(locationData)
    }
    
    func disconnect() {
        usbDevice = nil
        isConnected = false
    }
    
    deinit {
        disconnect()
        cancellables.removeAll()
    }
} 