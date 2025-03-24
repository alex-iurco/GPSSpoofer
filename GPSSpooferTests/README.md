# GPSSpoofer Tests

This directory contains unit tests for the GPSSpoofer application.

## Setup Instructions

To add these tests to your Xcode project:

1. Open your GPSSpoofer.xcodeproj in Xcode
2. Go to File > New > Target
3. Select "Unit Testing Bundle" from the template list
4. Name it "GPSSpooferTests" and make sure it's set to test the GPSSpoofer target
5. Click "Finish"

## Manual Integration

If you prefer to manually integrate these tests:

1. Add the files from this directory to your newly created test target
2. Make sure the target's Info.plist matches the one provided in the Info directory
3. Add the test target to your scheme:
   - Select Product > Scheme > Edit Scheme
   - Select the "Test" action
   - Click the "+" button to add your test target
   - Check the boxes next to your test cases

## Test Organization

- **Tests/**: Contains the actual test case files
  - `ConnectionTests.swift`: Tests for iPhone connection detection

- **Mocks/**: Contains mock implementations of services
  - `MockConnectionService.swift`: A mock implementation of the ConnectionServiceProtocol

## Running Tests

To run the tests:

1. Select Product > Test or press ⌘+U
2. View the test results in the Test Navigator or Test Report

## Writing New Tests

When writing new tests:

1. Follow the existing pattern of using dependency injection with mock services
2. Use the ServiceProvider to inject mock services 
3. Place new mock services in the Mocks directory
4. Place new test cases in the Tests directory
5. Ensure each test follows the Arrange-Act-Assert pattern

## Testing Philosophy

The tests follow these principles:

1. **Isolation**: Each test is isolated from external systems
2. **Determinism**: Tests produce the same result every time
3. **Speed**: Tests execute quickly with minimal setup
4. **Coverage**: Tests cover key functionality of the application 