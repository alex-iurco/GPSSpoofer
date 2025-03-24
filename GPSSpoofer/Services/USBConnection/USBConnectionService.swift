import Foundation
import SwiftUI
import Combine

/// Service that provides USB connection functionality to the application
class USBConnectionService: ObservableObject {
    /// The shared instance of the USB connection service
    static let shared = USBConnectionService()
    
    /// The current state of the USB connection
    @Published private(set) var connectionState: USBConnectionState = .disconnected
    
    /// The connection manager that handles USB device events
    private let connectionManager = USBConnectionManager()
    
    /// The subscription ID for the connection manager
    private var subscriptionId: UUID?
    
    /// Private initializer to enforce singleton pattern
    private init() {
        setupSubscription()
    }
    
    /// Set up the subscription to the connection manager
    private func setupSubscription() {
        subscriptionId = connectionManager.subscribe { [weak self] state in
            self?.connectionState = state
        }
    }
    
    /// Get the current connection state
    var isConnected: Bool {
        connectionState.isConnected
    }
    
    /// Manually refresh the connection state
    func refreshConnectionState() {
        connectionManager.refreshConnectionState()
    }
    
    deinit {
        if let subscriptionId = subscriptionId {
            connectionManager.unsubscribe(id: subscriptionId)
        }
    }
}
