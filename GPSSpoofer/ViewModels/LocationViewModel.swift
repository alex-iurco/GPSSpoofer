import Foundation
import SwiftUI

class LocationViewModel: ObservableObject {
    @Published var location: Location
    @Published var isConnected: Bool = false
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    
    private let deviceService: DeviceService
    
    init(deviceService: DeviceService = USBDeviceService()) {
        self.deviceService = deviceService
        self.location = Location(latitude: 0, longitude: 0, altitude: 0)
    }
    
    func connect() {
        isConnected = deviceService.connect()
        if isConnected {
            alertMessage = "Device connected successfully"
        } else {
            alertMessage = "Failed to connect to device"
        }
        showingAlert = true
    }
    
    func disconnect() {
        deviceService.disconnect()
        isConnected = false
    }
    
    func updateLocation() {
        guard location.isValid else {
            alertMessage = "Invalid location values"
            showingAlert = true
            return
        }
        
        let success = deviceService.sendLocation(location)
        alertMessage = success ? "Location updated successfully" : "Failed to update location"
        showingAlert = true
    }
    
    func updateLatitude(_ value: Double) {
        location = Location(
            latitude: value,
            longitude: location.longitude,
            altitude: location.altitude
        )
    }
    
    func updateLongitude(_ value: Double) {
        location = Location(
            latitude: location.latitude,
            longitude: value,
            altitude: location.altitude
        )
    }
    
    func updateAltitude(_ value: Double) {
        location = Location(
            latitude: location.latitude,
            longitude: location.longitude,
            altitude: value
        )
    }
} 