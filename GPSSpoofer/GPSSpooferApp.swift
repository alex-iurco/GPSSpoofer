import SwiftUI
import Combine

@main
struct GPSSpooferApp: App {
    // Initialize USB connection service
    @StateObject private var usbConnectionService = USBConnectionService.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 400, minHeight: 300)
                .padding()
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
    }
} 