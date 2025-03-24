//  ContentView.swift
//  GPSSpoofer

import SwiftUI
import MapKit
import Combine

struct ContentView: View {
    // Use the shared USB connection service
    @ObservedObject private var usbConnectionService = USBConnectionService.shared
    
    // Map state
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.67, longitude: -122.12),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Fixed width for the control panel
    // 
    private let controlPanelWidth: CGFloat = 250
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: Control panel - fixed width
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
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(usbConnectionService.isConnected ? .green : .red)
                        .frame(width: 8, height: 8)
                    Text(usbConnectionService.isConnected ? "Connected" : "Not Connected")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
                
                Text(connectionStateMessage)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 16)
                
                // Space for future features
                
                Spacer()
            }
            .frame(width: controlPanelWidth)
            .background(Color(NSColor.windowBackgroundColor))
            
            // Right side: Map View - expands to fill remaining space
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
                .background(Color.clear) // Remove the blue background entirely
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

extension ContentView {
    // Helper to get a more detailed connection state message
    var connectionStateMessage: String {
        switch usbConnectionService.connectionState {
        case .connected:
            return "Connected to USB device"
        case .disconnected:
            return "No device connected"
        case .error(let message):
            return "Connection error: \(message)"
        }
    }
}

struct CustomMapView: NSViewRepresentable {
    @Binding var region: MKCoordinateRegion
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: false)
        customizeAttributionButton(mapView)
        return mapView
    }
    
    func updateNSView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
    }
    
    private func customizeAttributionButton(_ mapView: MKMapView) {
        guard let button = mapView.subviews.compactMap({ $0 as? NSButton }).first else { return }
        
        // Style modifications
        button.alphaValue = 0.6
        button.isBordered = false
        button.font = NSFont.systemFont(ofSize: 9)
        
        // Constraint adjustments
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
