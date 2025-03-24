#!/bin/bash

# Script to verify that test files would compile
# This doesn't actually run the tests (XCTest requires a proper Xcode environment)
# But it can help catch basic syntax errors before committing

echo "Verifying test files compilation..."

# Check if Swift compiler exists
if ! command -v swiftc &> /dev/null; then
    echo "Swift compiler not found. Make sure Xcode command line tools are installed."
    exit 1
fi

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Create a temporary directory for compilation
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Get the base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PARENT_DIR="$(dirname "$BASE_DIR")"

# Copy test files to temp directory 
mkdir -p "$TEMP_DIR/Mocks"
mkdir -p "$TEMP_DIR/Tests"
cp "$BASE_DIR/Mocks/MockConnectionService.swift" "$TEMP_DIR/Mocks/"
cp "$BASE_DIR/Tests/ConnectionTests.swift" "$TEMP_DIR/Tests/"

# Create a dummy module to simulate the main app module
cat > "$TEMP_DIR/GPSSpoofer.swift" << EOF
import Foundation
import Combine

// Minimal implementations to allow compilation
public enum USBConnectionState: Equatable {
    case connected
    case disconnected
    case error(String)
}

public protocol ConnectionServiceProtocol: ObservableObject {
    var connectionState: USBConnectionState { get }
    var isConnected: Bool { get }
    var connectionStatePublisher: AnyPublisher<USBConnectionState, Never> { get }
    func connect() -> Bool
    func disconnect()
    func isDeviceAvailable() -> Bool
}

extension ConnectionServiceProtocol {
    public var isConnected: Bool {
        if case .connected = connectionState {
            return true
        }
        return false
    }
}

public class ServiceProvider {
    public static let shared = ServiceProvider()
    private var _connectionService: ConnectionServiceProtocol?
    
    public func makeConnectionViewModel() -> ConnectionViewModel {
        return ConnectionViewModel(connectionService: _connectionService!)
    }
    
    public func setConnectionService(_ service: ConnectionServiceProtocol) {
        _connectionService = service
    }
}

public enum ConnectionState: Equatable {
    case connected
    case disconnected
    case connecting
    case error(String)
    
    public static func from(usbState: USBConnectionState) -> ConnectionState {
        switch usbState {
        case .connected: return .connected
        case .disconnected: return .disconnected
        case .error(let msg): return .error(msg)
        }
    }
}

public class ConnectionViewModel: ObservableObject {
    @Published public private(set) var connectionState: ConnectionState = .disconnected
    @Published public private(set) var isConnected: Bool = false
    @Published public private(set) var connectionMessage: String = "No device connected"
    
    private let connectionService: ConnectionServiceProtocol
    
    public init(connectionService: ConnectionServiceProtocol) {
        self.connectionService = connectionService
        
        connectionService.connectionStatePublisher
            .sink { [weak self] state in
                switch state {
                case .connected:
                    self?.isConnected = true
                    self?.connectionMessage = "Connected to USB device"
                case .disconnected:
                    self?.isConnected = false
                    self?.connectionMessage = "No device connected"
                case .error(let message):
                    self?.isConnected = false
                    self?.connectionMessage = "Connection error: \(message)"
                }
            }
    }
    
    public func connect() -> Bool {
        return connectionService.connect()
    }
    
    public func disconnect() {
        connectionService.disconnect()
    }
}

class USBConnectionService {
    static let shared = USBConnectionService()
    var connectionState: USBConnectionState = .disconnected
    
    private init() {}
}
EOF

# Attempt to compile the mock
echo "Checking MockConnectionService.swift..."
if swiftc -parse "$TEMP_DIR/GPSSpoofer.swift" "$TEMP_DIR/Mocks/MockConnectionService.swift" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ MockConnectionService.swift syntax looks good${NC}"
else
    echo -e "${RED}✗ Syntax issues in MockConnectionService.swift${NC}"
    swiftc -parse "$TEMP_DIR/GPSSpoofer.swift" "$TEMP_DIR/Mocks/MockConnectionService.swift"
    RESULT=1
fi

# Attempt to compile the test
echo "Checking ConnectionTests.swift..."
if swiftc -parse "$TEMP_DIR/GPSSpoofer.swift" "$TEMP_DIR/Mocks/MockConnectionService.swift" "$TEMP_DIR/Tests/ConnectionTests.swift" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ ConnectionTests.swift syntax looks good${NC}"
else
    echo -e "${RED}✗ Syntax issues in ConnectionTests.swift${NC}"
    swiftc -parse "$TEMP_DIR/GPSSpoofer.swift" "$TEMP_DIR/Mocks/MockConnectionService.swift" "$TEMP_DIR/Tests/ConnectionTests.swift"
    RESULT=1
fi

# Clean up
rm -rf "$TEMP_DIR"

echo ""
echo "NOTE: This script only checks basic syntax."
echo "For full test validation, follow the instructions in How_To_Run_Tests.md"
echo "to add these files to an Xcode test target and run them properly."

exit ${RESULT:-0} 