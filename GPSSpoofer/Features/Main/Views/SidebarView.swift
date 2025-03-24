import SwiftUI

/// The sidebar view containing app navigation and controls
struct SidebarView: View {
    // MARK: - Properties
    
    @ObservedObject var connectionViewModel: ConnectionViewModel
    private let sidebarWidth: CGFloat = 250
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // App Title
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
            
            // Connection Status Section
            VStack(alignment: .leading, spacing: 4) {
                Text("Device Connection")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                ConnectionControlsView(viewModel: connectionViewModel)
            }
            .padding(.vertical, 4)
            
            // Future sections can be added here
            
            Spacer()
        }
        .frame(width: sidebarWidth)
        .background(Color(NSColor.windowBackgroundColor))
        .padding(.horizontal, 0)
    }
}

#if DEBUG
// MARK: - Preview

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ConnectionViewModel()
        
        return SidebarView(connectionViewModel: viewModel)
            .frame(height: 500)
            .previewDisplayName("Sidebar")
    }
}
#endif
