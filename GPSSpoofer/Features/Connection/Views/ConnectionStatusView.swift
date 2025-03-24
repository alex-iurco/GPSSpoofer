import SwiftUI

/// A reusable view component that displays connection status
struct ConnectionStatusView: View {
    // MARK: - Properties
    
    /// The view model that provides connection state
    @ObservedObject var viewModel: ConnectionViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                // Status indicator
                Circle()
                    .fill(viewModel.isConnected ? .green : .red)
                    .frame(width: 8, height: 8)
                
                // Status text
                Text(viewModel.isConnected ? "Connected" : "Not Connected")
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            // Detailed status message
            Text(viewModel.connectionMessage)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

/// A view that provides more detailed connection information and controls
struct ConnectionControlsView: View {
    // MARK: - Properties
    
    /// The view model that provides connection state and actions
    @ObservedObject var viewModel: ConnectionViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Status section
            ConnectionStatusView(viewModel: viewModel)
            
            Divider()
            
            // Controls section
            if !viewModel.isConnected {
                if viewModel.isDeviceAvailable() {
                    Button("Connect Device") {
                        _ = viewModel.connect()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .padding(.top, 4)
                } else {
                    Text("No USB devices available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                }
            } else {
                Button("Disconnect") {
                    viewModel.disconnect()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
// MARK: - Preview

struct ConnectionStatusView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with connected state
        let connectedViewModel = ConnectionViewModel()
        
        // Preview with disconnected state
        let disconnectedViewModel = ConnectionViewModel()
        
        return Group {
            ConnectionStatusView(viewModel: connectedViewModel)
                .frame(width: 250)
                .padding()
                .previewDisplayName("Connected")
                .onAppear {
                    // This is just for preview and doesn't affect real functionality
                }
            
            ConnectionControlsView(viewModel: disconnectedViewModel)
                .frame(width: 250)
                .padding()
                .previewDisplayName("Disconnected")
        }
    }
}
#endif
