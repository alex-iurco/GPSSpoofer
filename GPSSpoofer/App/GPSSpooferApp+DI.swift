import SwiftUI
import Combine

/// Extension to GPSSpooferApp that adds dependency injection support
extension GPSSpooferApp {
    /// Creates the main content view with proper dependency injection
    func makeContentView() -> some View {
        let serviceProvider = ServiceProvider.shared
        let connectionViewModel = serviceProvider.makeConnectionViewModel()
        
        return MainView(connectionViewModel: connectionViewModel)
    }
    
    /// Registers the app lifecycle observers
    func registerLifecycleObservers() {
        // Any app-wide lifecycle observers can be registered here
        // This helps centralize lifecycle management
    }
    
    /// Performs initial app setup
    func performSetup() {
        // Initialize any services that need to be started at app launch
        // Configure global settings
        // Set up logging
    }
}
