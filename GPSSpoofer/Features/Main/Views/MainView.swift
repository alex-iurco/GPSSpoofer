import SwiftUI
import MapKit
import Combine

/// The main view of the application
struct MainView: View {
    // MARK: - Properties
    
    @ObservedObject var connectionViewModel: ConnectionViewModel
    @StateObject private var mapViewModel = MapViewModel()
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: Control panel
            SidebarView(connectionViewModel: connectionViewModel)
            
            // Right side: Map View
            MapContentView(region: $mapViewModel.region)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

/// The sidebar view containing connection status and controls
struct SidebarView: View {
    // MARK: - Properties
    
    @ObservedObject var connectionViewModel: ConnectionViewModel
    private let controlPanelWidth: CGFloat = 250
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("GPS Spoofer")
                .font({
                    if #available(macOS 13.0, *) {
                        return .system(.title3, weight: .semibold)
                    } else {
                        return .system(size: 14, weight: .semibold)
                    }
                }())
                .foregroundColor(.primary)
                .padding(.top, 20)
            
            Divider()
            
            ConnectionStatusView(isConnected: connectionViewModel.isConnected, 
                                 connectionMessage: connectionViewModel.connectionMessage)
            
            // Space for future controls
            
            Spacer()
        }
        .frame(width: controlPanelWidth)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

/// A view that displays the connection status
struct ConnectionStatusView: View {
    // MARK: - Properties
    
    let isConnected: Bool
    let connectionMessage: String
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(isConnected ? .green : .red)
                .frame(width: 8, height: 8)
            Text(isConnected ? "Connected" : "Not Connected")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
        
        Text(connectionMessage)
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.bottom, 16)
    }
}

/// A view that displays the map
struct MapContentView: View {
    // MARK: - Properties
    
    @Binding var region: MKCoordinateRegion
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            CustomMapView(region: $region)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Legal text at bottom
            HStack {
                Spacer()
                Text("Legal")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.7))
                    .padding(4)
            }
            .background(Color.clear)
        }
    }
}
