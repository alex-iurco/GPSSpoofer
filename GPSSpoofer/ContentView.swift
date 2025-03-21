import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isConnected = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var altitude: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            // Title and Status
            Text("GPS Spoofer")
                .font(.title)
                .padding(.top)
            
            // Connection Status
            HStack {
                Circle()
                    .fill(isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                Text(isConnected ? "Connected" : "Not Connected")
                    .foregroundColor(isConnected ? .green : .red)
            }
            
            // Connect Button
            Button(action: {
                isConnected.toggle()
            }) {
                Text(isConnected ? "Disconnect" : "Connect")
                    .frame(width: 100)
            }
            .buttonStyle(.borderedProminent)
            .tint(isConnected ? .red : .blue)
            
            if isConnected {
                // GPS Input Fields
                VStack(spacing: 12) {
                    // Latitude Input
                    HStack {
                        Text("Latitude:")
                            .frame(width: 80, alignment: .trailing)
                        TextField("Enter latitude", text: $latitude)
                            .frame(width: 120)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Longitude Input
                    HStack {
                        Text("Longitude:")
                            .frame(width: 80, alignment: .trailing)
                        TextField("Enter longitude", text: $longitude)
                            .frame(width: 120)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Altitude Input
                    HStack {
                        Text("Altitude:")
                            .frame(width: 80, alignment: .trailing)
                        TextField("Enter altitude", text: $altitude)
                            .frame(width: 120)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Update Button
                    Button("Update Location") {
                        // TODO: Implement location update
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)
                }
                .padding()
            }
        }
        .frame(width: 300, height: 400)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 