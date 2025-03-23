//  ContentView.swift
//  GPSSpoofer

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isConnected = false
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var altitude = ""
    
    // Map state
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 47.67, longitude: -122.12),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // Fixed width for the control panel
    private let controlPanelWidth: CGFloat = 250
    
    var body: some View {
        HStack(spacing: 0) {
            // Left side: Control panel - fixed width
            VStack(alignment: .center, spacing: 16) {
                Text("GPS Spoofer")
                    .font(.system(size: 24, weight: .medium))
                    .padding(.top, 20)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(isConnected ? .green : .red)
                        .frame(width: 8, height: 8)
                    Text(isConnected ? "Connected" : "Not Connected")
                        .foregroundColor(isConnected ? .green : .red)
                }
                .padding(.bottom, 10)
                
                Button(action: {
                    isConnected.toggle()
                }) {
                    Text(isConnected ? "Disconnect" : "Connect")
                        .frame(minWidth: 100)
                }
                .buttonStyle(.borderedProminent)
                .tint(isConnected ? .red : .blue)
                
                if isConnected {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Latitude:")
                                .frame(width: 65, alignment: .trailing)
                            TextField("", text: $latitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                        
                        HStack {
                            Text("Longitude:")
                                .frame(width: 65, alignment: .trailing)
                            TextField("", text: $longitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                        
                        HStack {
                            Text("Altitude:")
                                .frame(width: 65, alignment: .trailing)
                            TextField("", text: $altitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                        
                        Button("Update Location") {
                            if let lat = Double(latitude), let lon = Double(longitude) {
                                region.center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(latitude.isEmpty || longitude.isEmpty || altitude.isEmpty)
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .frame(width: controlPanelWidth)
            .frame(maxHeight: .infinity)
            .background(Color(red: 0.2, green: 0.2, blue: 0.25))
            
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
