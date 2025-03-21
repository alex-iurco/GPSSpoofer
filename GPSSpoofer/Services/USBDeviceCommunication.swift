import Foundation
import IOKit
import IOKit.usb

class USBDeviceCommunication {
    // Device interface for communication
    private var deviceInterface: IOUSBDeviceInterface?
    
    // Open interfaces
    private var openInterfaces: [IOUSBInterfaceInterface] = []
    
    // Constants for USB communication
    private let kIOUSBDeviceUserClientTypeID = CFUUIDGetUUIDBytes(kIOUSBDeviceUserClientTypeID)
    private let kIOCFPlugInInterfaceID = CFUUIDGetUUIDBytes(kIOCFPlugInInterfaceID)
    private let kIOUSBInterfaceInterfaceID = CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID)
    
    // Location data packet format
    private let packetHeader: [UInt8] = [0x01, 0x02, 0x03, 0x04]
    
    func connectToDevice(with deviceRef: io_service_t) -> Bool {
        var plugInInterface: IOCFPlugInInterface?
        var score: Int32 = 0
        
        let result = IOCreatePlugInInterfaceForService(
            deviceRef,
            kIOUSBDeviceUserClientTypeID,
            kIOCFPlugInInterfaceID,
            &plugInInterface,
            &score
        )
        
        guard result == KERN_SUCCESS, plugInInterface != nil else {
            print("Failed to create plug-in interface")
            return false
        }
        
        // Get device interface
        var deviceInterfacePtr: UnsafeMutablePointer<UnsafeMutablePointer<IOUSBDeviceInterface>>?
        
        let res = withUnsafeMutablePointer(to: &deviceInterface) { deviceInterfacePtr in
            plugInInterface?.pointee.QueryInterface(
                plugInInterface,
                CFUUIDGetUUIDBytes(kIOUSBDeviceInterfaceID),
                deviceInterfacePtr
            )
        }
        
        guard res == KERN_SUCCESS, deviceInterface != nil else {
            print("Failed to get device interface")
            return false
        }
        
        // Open the device
        let openResult = deviceInterface?.pointee.USBDeviceOpen(deviceInterface)
        
        guard openResult == KERN_SUCCESS else {
            print("Failed to open device")
            return false
        }
        
        // Configure device for location data
        return configureDeviceForLocationData()
    }
    
    private func configureDeviceForLocationData() -> Bool {
        // Get the number of configurations
        var numConfigs: UInt8 = 0
        let configResult = deviceInterface?.pointee.GetNumberOfConfigurations(deviceInterface, &numConfigs)
        
        guard configResult == KERN_SUCCESS else {
            print("Failed to get number of configurations")
            return false
        }
        
        // Find the appropriate interface for sending location data
        for configIndex in 0..<Int(numConfigs) {
            var configDesc: IOUSBConfigurationDescriptor?
            let configDescResult = deviceInterface?.pointee.GetConfigurationDescriptor(
                deviceInterface,
                UInt8(configIndex),
                &configDesc
            )
            
            guard configDescResult == KERN_SUCCESS, configDesc != nil else {
                continue
            }
            
            // Set the configuration
            let setConfigResult = deviceInterface?.pointee.SetConfiguration(
                deviceInterface,
                UInt8(configIndex)
            )
            
            guard setConfigResult == KERN_SUCCESS else {
                continue
            }
            
            // Find and open the appropriate interface
            if findAndOpenInterface() {
                return true
            }
        }
        
        return false
    }
    
    private func findAndOpenInterface() -> Bool {
        var interfaceIterator: io_iterator_t = 0
        let interfaceResult = deviceInterface?.pointee.CreateInterfaceIterator(
            deviceInterface,
            &interfaceIterator
        )
        
        guard interfaceResult == KERN_SUCCESS else {
            return false
        }
        
        defer { IOObjectRelease(interfaceIterator) }
        
        var interface: io_service_t = IOIteratorNext(interfaceIterator)
        while interface != 0 {
            defer { IOObjectRelease(interface) }
            
            var plugInInterface: IOCFPlugInInterface?
            var score: Int32 = 0
            
            let result = IOCreatePlugInInterfaceForService(
                interface,
                kIOUSBInterfaceInterfaceID,
                kIOCFPlugInInterfaceID,
                &plugInInterface,
                &score
            )
            
            if result == KERN_SUCCESS, plugInInterface != nil {
                var interfaceInterface: UnsafeMutablePointer<UnsafeMutablePointer<IOUSBInterfaceInterface>>?
                
                let res = withUnsafeMutablePointer(to: &interfaceInterface) { interfacePtr in
                    plugInInterface?.pointee.QueryInterface(
                        plugInInterface,
                        CFUUIDGetUUIDBytes(kIOUSBInterfaceInterfaceID),
                        interfacePtr
                    )
                }
                
                if res == KERN_SUCCESS, interfaceInterface != nil {
                    let openResult = interfaceInterface?.pointee.USBInterfaceOpen(interfaceInterface)
                    
                    if openResult == KERN_SUCCESS {
                        openInterfaces.append(interfaceInterface!)
                        return true
                    }
                }
            }
            
            interface = IOIteratorNext(interfaceIterator)
        }
        
        return false
    }
    
    func sendLocationData(latitude: Double, longitude: Double, altitude: Double) -> Bool {
        let packet = formatLocationPacket(latitude: latitude, longitude: longitude, altitude: altitude)
        return sendDataToDevice(data: packet)
    }
    
    private func formatLocationPacket(latitude: Double, longitude: Double, altitude: Double) -> Data {
        var packet = Data()
        
        // Magic number for iOS location simulation
        packet.append(contentsOf: [0xFF, 0xAA, 0x55, 0xBB])
        
        // Command type: Location update (0x01)
        packet.append(0x01)
        
        // Packet length (32 bytes: 8 for each double + 8 for timestamp)
        packet.append(UInt8(32))
        
        // Add latitude (8 bytes - double)
        withUnsafeBytes(of: latitude.bitPattern.bigEndian) { bytes in
            packet.append(contentsOf: bytes)
        }
        
        // Add longitude (8 bytes - double)
        withUnsafeBytes(of: longitude.bitPattern.bigEndian) { bytes in
            packet.append(contentsOf: bytes)
        }
        
        // Add altitude (8 bytes - double)
        withUnsafeBytes(of: altitude.bitPattern.bigEndian) { bytes in
            packet.append(contentsOf: bytes)
        }
        
        // Add timestamp (8 bytes - uint64)
        let timestamp = UInt64(Date().timeIntervalSince1970 * 1000).bigEndian
        withUnsafeBytes(of: timestamp) { bytes in
            packet.append(contentsOf: bytes)
        }
        
        // Add checksum (XOR of all bytes)
        var checksum: UInt8 = 0
        for byte in packet {
            checksum ^= byte
        }
        packet.append(checksum)
        
        return packet
    }
    
    private func sendDataToDevice(data: Data) -> Bool {
        guard let interface = openInterfaces.first else {
            return false
        }
        
        // Find the appropriate endpoint for sending data
        var numEndpoints: UInt8 = 0
        let endpointResult = interface.pointee.GetNumEndpoints(interface, &numEndpoints)
        
        guard endpointResult == KERN_SUCCESS else {
            return false
        }
        
        // Try each endpoint until we find one that works
        for endpointIndex in 0..<Int(numEndpoints) {
            var endpoint: IOUSBEndpointDescriptor?
            let endpointResult = interface.pointee.GetEndpointDescriptor(
                interface,
                UInt8(endpointIndex),
                &endpoint
            )
            
            guard endpointResult == KERN_SUCCESS, endpoint != nil else {
                continue
            }
            
            // Check if this is an OUT endpoint
            if (endpoint?.bEndpointAddress ?? 0) & 0x80 == 0 {
                let writeResult = interface.pointee.WritePipe(
                    interface,
                    UInt8(endpointIndex),
                    data.baseAddress,
                    UInt32(data.count)
                )
                
                if writeResult == KERN_SUCCESS {
                    return true
                }
            }
        }
        
        return false
    }
    
    func disconnect() {
        // Close all open interfaces
        for interface in openInterfaces {
            _ = interface.pointee.USBInterfaceClose(interface)
            _ = interface.pointee.Release(interface)
        }
        openInterfaces.removeAll()
        
        // Close device
        if deviceInterface != nil {
            _ = deviceInterface?.pointee.USBDeviceClose(deviceInterface)
            _ = deviceInterface?.pointee.Release(deviceInterface)
            deviceInterface = nil
        }
    }
} 