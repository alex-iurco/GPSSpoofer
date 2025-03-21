import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isConnected = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var altitude: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // Title
            Text("GPS Spoofer")
                .font(.system(size: 24, weight: .medium))
                .padding(.top, 12)
            
            // Connection Status
            HStack(spacing: 6) {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                Text(isConnected ? "Connected" : "Not Connected")
                    .foregroundColor(isConnected ? .green : .red)
                    .font(.system(size: 13))
            }
            
            // Connect Button
            Button(action: {
                isConnected.toggle()
            }) {
                Text(isConnected ? "Disconnect" : "Connect")
                    .frame(minWidth: 100)
            }
            .buttonStyle(.borderedProminent)
            .tint(isConnected ? .red : .blue)
            
            if isConnected {
                // GPS Input Fields
                VStack(spacing: 12) {
                    Group {
                        // Latitude Input
                        HStack {
                            Text("Latitude:")
                                .frame(width: 65, alignment: .trailing)
                                .font(.system(size: 13))
                            TextField("", text: $latitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                        
                        // Longitude Input
                        HStack {
                            Text("Longitude:")
                                .frame(width: 65, alignment: .trailing)
                                .font(.system(size: 13))
                            TextField("", text: $longitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                        
                        // Altitude Input
                        HStack {
                            Text("Altitude:")
                                .frame(width: 65, alignment: .trailing)
                                .font(.system(size: 13))
                            TextField("", text: $altitude)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 120)
                        }
                    }
                    
                    // Update Button
                    Button("Update Location") {
                        // TODO: Implement location update
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!isConnected)
                    .padding(.top, 4)
                }
                .padding(.vertical, 8)
            }
            
            Spacer()
        }
        .frame(width: 250, height: isConnected ? 300 : 150)
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 