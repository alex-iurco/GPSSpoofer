import Foundation

/// Defines the interface for USB communication with devices
protocol USBCommunicationProtocol {
    /// Attempts to connect to a USB device
    /// - Parameter service: Optional service identifier
    /// - Returns: True if connection was successful, false otherwise
    func connectToDevice(service: Int) -> Bool
    
    /// Disconnects from the currently connected device
    func disconnectFromDevice()
    
    /// Sends data to the connected device
    /// - Parameter data: The data to send
    /// - Returns: True if the data was sent successfully, false otherwise
    func sendData(_ data: Data) -> Bool
    
    /// Reads data from the connected device
    /// - Returns: The data read from the device, or nil if no data was available
    func readData() -> Data?
    
    /// Checks if the device is still connected
    /// - Returns: True if the device is connected, false otherwise
    func isDeviceConnected() -> Bool
}
