import Foundation
import IOKit
import os.log
import SwiftUI

/// A class that manages USB device connections and provides notifications when devices are connected or disconnected
class USBConnectionManager: ObservableObject {
    /// The current state of the USB connection
    @Published private(set) var connectionState: USBConnectionState = .disconnected
    
    /// Logger for recording connection events
    private let logger = Logger(subsystem: "com.gpsspoofer", category: "USBConnectionManager")
    
    /// Center for system notifications
    private let notificationCenter = NotificationCenter.default
    
    /// Subscribers for connection state changes
    private var subscribers: [UUID: (USBConnectionState) -> Void] = [:]
    
    /// Queue for thread safety when modifying state
    private let queue = DispatchQueue(label: "com.gpsspoofer.usbconnection", qos: .userInitiated)
    
    /// Timer for periodic USB device scan
    private var scanTimer: Timer?
    
    /// Initialize the USB connection manager and start monitoring for device connections
    init() {
        // Set up notifications for when the app becomes active
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: NSApplication.didBecomeActiveNotification,
            object: nil
        )
        
        // Set up notifications for when the app is about to terminate
        notificationCenter.addObserver(
            self,
            selector: #selector(applicationWillTerminate),
            name: NSApplication.willTerminateNotification,
            object: nil
        )
        
        // Start monitoring for USB devices
        startMonitoring()
    }
    
    /// Start monitoring for USB devices
    private func startMonitoring() {
        // Initially check for connected devices
        checkForConnectedDevices()
        
        // Set up a timer to periodically check for devices
        scanTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkForConnectedDevices()
        }
    }
    
    /// Check for connected USB devices
    private func checkForConnectedDevices() {
        // Implement a more specific check for iOS devices
        let matchingDict = IOServiceMatching("IOUSBHostDevice")
        var iterator: io_iterator_t = 0
        
        let result = IOServiceGetMatchingServices(kIOMainPortDefault, matchingDict, &iterator)
        
        var iOSDeviceFound = false
        
        if result == kIOReturnSuccess {
            var device: io_service_t = 0
            repeat {
                device = IOIteratorNext(iterator)
                if device != 0 {
                    // Check if this is an Apple device by checking its properties
                    if isAppleMobileDevice(device) {
                        iOSDeviceFound = true
                        logger.info("iOS device found")
                    }
                    IOObjectRelease(device)
                }
            } while device != 0
            
            IOObjectRelease(iterator)
        }
        
        if iOSDeviceFound && connectionState != .connected {
            logger.info("iOS device detected via USB")
            updateState(.connected)
        } else if !iOSDeviceFound && connectionState == .connected {
            logger.info("iOS device disconnected")
            updateState(.disconnected)
        }
    }
    
    /// Check if a device is an Apple mobile device (iPhone, iPad, etc.)
    private func isAppleMobileDevice(_ device: io_service_t) -> Bool {
        // Get the device properties
        var propertiesRef: Unmanaged<CFMutableDictionary>?
        let result = IORegistryEntryCreateCFProperties(device, &propertiesRef, kCFAllocatorDefault, 0)
        
        guard result == kIOReturnSuccess,
              let properties = propertiesRef?.takeRetainedValue() as? [String: Any] else {
            return false
        }
        
        // Check for Apple vendor ID (0x05ac)
        if let vendorID = properties["idVendor"] as? Int, vendorID == 0x05ac {
            // Check for product IDs that correspond to iOS devices
            // This is a subset, but covers most iPhones
            if let productID = properties["idProduct"] as? Int {
                // Product IDs for iOS devices typically fall in certain ranges
                // This is a simplified check
                return (productID >= 0x1290 && productID <= 0x12AF) // Common iPhone range
                    || (productID >= 0x1290 && productID <= 0x12AF) // Various iPhone models
                    || productID == 0x12a8 // iPhone
                    || productID == 0x12a9 // iPhone 3G
                    || productID == 0x12aa // iPhone 3GS
            }
        }
        
        // Check USB device name for common identifiers
        if let productName = properties["USB Product Name"] as? String {
            return productName.lowercased().contains("iphone") ||
                   productName.lowercased().contains("ipad") ||
                   productName.lowercased().contains("ipod")
        }
        
        return false
    }
    
    /// Called when the application becomes active
    @objc private func applicationDidBecomeActive() {
        // Refresh device status when the app becomes active
        checkForConnectedDevices()
    }
    
    /// Called when the application is about to terminate
    @objc private func applicationWillTerminate() {
        // Clean up resources
        scanTimer?.invalidate()
        scanTimer = nil
    }
    
    /// Update the connection state and notify subscribers
    /// - Parameter newState: The new connection state
    private func updateState(_ newState: USBConnectionState) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            // Only update if state has changed
            if self.connectionState != newState {
                DispatchQueue.main.async {
                    self.connectionState = newState
                    
                    // Notify all subscribers of the state change
                    for subscriber in self.subscribers.values {
                        subscriber(newState)
                    }
                }
            }
        }
    }
    
    /// Subscribe to connection state changes
    /// - Parameter callback: The callback to be called when the connection state changes
    /// - Returns: A UUID that can be used to unsubscribe
    func subscribe(callback: @escaping (USBConnectionState) -> Void) -> UUID {
        let id = UUID()
        queue.async { [weak self] in
            self?.subscribers[id] = callback
            
            // Immediately notify the new subscriber of the current state
            if let currentState = self?.connectionState {
                DispatchQueue.main.async {
                    callback(currentState)
                }
            }
        }
        return id
    }
    
    /// Unsubscribe from connection state changes
    /// - Parameter id: The UUID returned from the subscribe method
    func unsubscribe(id: UUID) {
        queue.async { [weak self] in
            self?.subscribers.removeValue(forKey: id)
        }
    }
    
    /// Force a manual refresh of the connection state
    func refreshConnectionState() {
        logger.info("Manual refresh of connection state requested")
        checkForConnectedDevices()
    }
    
    deinit {
        // Clean up resources
        scanTimer?.invalidate()
        
        // Remove notification observers
        notificationCenter.removeObserver(self)
        
        logger.info("USBConnectionManager deinitializing")
    }
}
