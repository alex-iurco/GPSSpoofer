import Foundation

protocol DeviceService {
    var isConnected: Bool { get }
    func connect() -> Bool
    func disconnect()
    func sendLocation(_ location: Location) -> Bool
}

enum DeviceError: Error {
    case connectionFailed
    case invalidLocation
    case communicationError
    case deviceNotFound
} 