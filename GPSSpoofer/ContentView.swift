import SwiftUI

struct ContentView: View {
    @StateObject private var locationService = LocationService()
    @StateObject private var connectionService = ConnectionService()
    
    var body: some View {
        VStack {
            Text("GPS Spoofer")
                .font(.title)
                .padding()
            
            if connectionService.isConnected {
                Text("Connected to iOS Device")
                    .foregroundColor(.green)
            } else {
                Text("Not Connected")
                    .foregroundColor(.red)
            }
            
            Button(connectionService.isConnected ? "Disconnect" : "Connect") {
                if connectionService.isConnected {
                    connectionService.disconnect()
                } else {
                    connectionService.connect()
                }
            }
            .padding()
            
            // Location input fields will go here
        }
        .padding()
    }
} 