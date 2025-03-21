import Foundation
import IOKit
import IOKit.usb
import os.log

class USBDeviceService: DeviceService {
    private let deviceManager: DeviceManager
    private var _isConnected: Bool = false
    private let logger = Logger(subsystem: "com.gpsspoofer", category: "USBDeviceService")
    
    var isConnected: Bool {
        get { _isConnected }
    }
    
    init() {
        self.deviceManager = DeviceManager()
    }
    
    func connect() -> Bool {
        logger.info("Attempting to connect to device...")
        _isConnected = deviceManager.startDeviceDiscovery()
        
        if _isConnected {
            logger.info("Successfully connected to device")
        } else {
            logger.error("Failed to connect to device")
        }
        
        return _isConnected
    }
    
    func disconnect() {
        logger.info("Disconnecting from device...")
        deviceManager.disconnect()
        _isConnected = false
    }
    
    func sendLocation(_ location: Location) -> Bool {
        guard location.isValid else {
            logger.error("Invalid location data: lat=\(location.latitude), lon=\(location.longitude), alt=\(location.altitude)")
            return false
        }
        
        logger.info("Sending location update: lat=\(location.latitude), lon=\(location.longitude), alt=\(location.altitude)")
        
        let success = deviceManager.sendLocationUpdate(
            latitude: location.latitude,
            longitude: location.longitude,
            altitude: location.altitude
        )
        
        if success {
            logger.info("Location update sent successfully")
        } else {
            logger.error("Failed to send location update")
        }
        
        return success
    }
} 