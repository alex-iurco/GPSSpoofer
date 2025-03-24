import XCTest
import Combine
@testable import GPSSpoofer

class ConnectionTests: XCTestCase {
    // Test objects
    private var mockConnectionService: MockConnectionService!
    private var serviceProvider: ServiceProvider!
    private var connectionViewModel: ConnectionViewModel!
    
    // Cancellables for Combine subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        // Create mock service with disconnected initial state
        mockConnectionService = MockConnectionService(initialState: .disconnected)
        
        // Get the singleton service provider
        serviceProvider = ServiceProvider.shared
        
        // Replace the real connection service with our mock
        serviceProvider.setConnectionService(mockConnectionService)
        
        // Create the view model using the service provider
        connectionViewModel = serviceProvider.makeConnectionViewModel()
    }
    
    override func tearDown() {
        // Clean up
        cancellables.removeAll()
        mockConnectionService = nil
        connectionViewModel = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    /// Tests that the iPhone is detected as connected when the connection service reports connected state
    func testIPhoneConnected() {
        // Arrange - Set up an expectation for the async state change
        let expectation = XCTestExpectation(description: "iPhone connection detected")
        
        // Subscribe to isConnected changes on the view model
        connectionViewModel.$isConnected
            .dropFirst() // Skip the initial value
            .sink { isConnected in
                if isConnected {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act - Simulate iPhone connection
        mockConnectionService.setConnectionState(.connected)
        
        // Assert - Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
        
        // Verify that isConnected is true
        XCTAssertTrue(connectionViewModel.isConnected, "iPhone should be detected as connected")
        XCTAssertEqual(connectionViewModel.connectionMessage, "Connected to USB device", "Connection message should indicate connected device")
    }
    
    /// Tests that the iPhone is detected as disconnected when the connection service reports disconnected state
    func testIPhoneDisconnected() {
        // Arrange - Start with a connected state
        mockConnectionService.setConnectionState(.connected)
        
        // Set up expectation for the disconnect
        let expectation = XCTestExpectation(description: "iPhone disconnection detected")
        
        // Subscribe to isConnected changes
        connectionViewModel.$isConnected
            .dropFirst() // Skip the initial value
            .sink { isConnected in
                if !isConnected {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act - Simulate iPhone disconnection
        mockConnectionService.setConnectionState(.disconnected)
        
        // Assert - Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
        
        // Verify disconnected state
        XCTAssertFalse(connectionViewModel.isConnected, "iPhone should be detected as disconnected")
        XCTAssertEqual(connectionViewModel.connectionMessage, "No device connected", "Connection message should indicate no device")
    }
    
    /// Tests connecting to an iPhone via the connect() method
    func testConnectToIPhone() {
        // Arrange
        mockConnectionService.connectReturnValue = true
        
        // Act
        let result = connectionViewModel.connect()
        
        // Assert
        XCTAssertTrue(result, "Connect should return true when successful")
        XCTAssertEqual(mockConnectionService.connectCallCount, 1, "Connect method should be called once")
        XCTAssertTrue(connectionViewModel.isConnected, "View model should report connected state")
    }
    
    /// Tests that connection fails when no iPhone is available
    func testConnectionFailsWhenNoIPhoneAvailable() {
        // Arrange
        mockConnectionService.connectReturnValue = false
        
        // Act
        let result = connectionViewModel.connect()
        
        // Assert
        XCTAssertFalse(result, "Connect should return false when unsuccessful")
        XCTAssertEqual(mockConnectionService.connectCallCount, 1, "Connect method should be called once")
        XCTAssertFalse(connectionViewModel.isConnected, "View model should report disconnected state")
    }
    
    /// Tests disconnecting from an iPhone
    func testDisconnectFromIPhone() {
        // Arrange - Start with a connected state
        mockConnectionService.setConnectionState(.connected)
        
        // Act
        connectionViewModel.disconnect()
        
        // Assert
        XCTAssertEqual(mockConnectionService.disconnectCallCount, 1, "Disconnect method should be called once")
        XCTAssertFalse(connectionViewModel.isConnected, "View model should report disconnected state after disconnect")
    }
    
    /// Tests error handling when iPhone connection encounters an error
    func testIPhoneConnectionError() {
        // Arrange - Set up an expectation for the async state change
        let expectation = XCTestExpectation(description: "iPhone connection error detected")
        let errorMessage = "USB Communication Error"
        
        // Subscribe to connectionMessage changes on the view model
        connectionViewModel.$connectionMessage
            .dropFirst() // Skip the initial value
            .sink { message in
                if message.contains(errorMessage) {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act - Simulate connection error
        mockConnectionService.setConnectionState(.error(errorMessage))
        
        // Assert - Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1.0)
        
        // Verify error state
        XCTAssertFalse(connectionViewModel.isConnected, "iPhone should not be connected when there's an error")
        XCTAssertTrue(connectionViewModel.connectionMessage.contains(errorMessage), "Connection message should contain the error message")
    }
} 