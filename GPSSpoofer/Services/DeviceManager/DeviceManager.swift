import Foundation

class DeviceManager: ObservableObject {
    @Published var isConnected = false
    private var usbDevice: USBDeviceCommunication?
    
    init() {
        usbDevice = nil
        isConnected = false
    }
    
    func startDeviceDiscovery() -> Bool {
        // Create dummy USB device communication instance
        usbDevice = USBDeviceCommunication()
        
        // Simulate connecting to a device
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
    }
} 