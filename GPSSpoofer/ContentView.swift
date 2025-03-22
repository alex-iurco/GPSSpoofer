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
        GeometryReader { geometry in // Use GeometryReader for responsive layout
            HStack {
                // Right Side: Existing Controls (moved from left)
                VStack(alignment: .leading, spacing: 16) {
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
                .frame(maxWidth: .infinity)
                
                // Left Side: Map View (moved from right)
                VStack {
                    Map(coordinateRegion: $region)
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height) // Responsive width
                    // Map Controls
                    HStack {
                        Button("Zoom In") {
                            // Zoom in logic
                        }
                        Button("Zoom Out") {
                            // Zoom out logic
                        }
                        Button("Center Map") {
                            region.center = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0, longitude: Double(longitude) ?? 0)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// #Preview {
//     ContentView()
// }
