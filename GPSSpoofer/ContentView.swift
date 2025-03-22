//  ContentView.swift
//  GPSSpoofer

import SwiftUI
import MapKit // Import MapKit for map functionality

struct ContentView: View {
    @State private var isConnected = false
    @State private var latitude = ""
    @State private var longitude = ""
    @State private var altitude = ""
    
    // Map state
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        HStack { // Use HStack for side-by-side layout
            // Left Side: Map View
            VStack {
                Map(coordinateRegion: $region) // Map view
                    .frame(width: 250, height: 300) // Set frame size
                
                // Map Controls
                HStack {
                    Button("Zoom In") {
                        // Zoom in logic
                    }
                    Button("Zoom Out") {
                        // Zoom out logic
                    }
                    Button("Center Map") {
                        // Center map logic
                        region.center = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
                    }
                    // Map type selector (could be a Picker)
                }
            }
            
            // Right Side: Existing Controls
            VStack(alignment: .center, spacing: 16) {
                Text("GPS Spoofer")
                    .font(.system(size: 24, weight: .medium))
                    .padding(.top, 12)
                
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
                            // Update location action
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(latitude.isEmpty || longitude.isEmpty || altitude.isEmpty)
                    }
                    .padding(.vertical)
                }
            }
        }
        .padding()
        .frame(width: 500, height: 300) // Adjusted window size
    }
}

// #Preview {
//     ContentView()
// }