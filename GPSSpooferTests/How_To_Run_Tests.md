# How to Run the Connection Tests Locally

To run the iPhone connection tests locally before committing:

## Step 1: Add the Test Target to Xcode Project

1. Open `GPSSpoofer.xcodeproj` in Xcode
2. Go to File > New > Target
3. Select "Unit Testing Bundle" under Test category
4. Name it "GPSSpooferTests"
5. Make sure "GPSSpoofer" is selected as the target to be tested
6. Click "Finish"

## Step 2: Add Existing Test Files to the Target

1. In Xcode's Project Navigator, right-click the "GPSSpooferTests" group
2. Select "Add Files to 'GPSSpooferTests'..."
3. Navigate to and select:
   - `GPSSpooferTests/Mocks/MockConnectionService.swift`
   - `GPSSpooferTests/Tests/ConnectionTests.swift`
4. Make sure "Copy items if needed" is unchecked
5. Ensure the "GPSSpooferTests" target is selected
6. Click "Add"

## Step 3: Run the Tests

1. Press ⌘+U or select Product > Test
2. View test results in the Test Navigator (⌘+6)

## Step 4: Troubleshooting Common Issues

### If tests fail with "No such module 'GPSSpoofer'":
1. Select the GPSSpooferTests target in Xcode
2. Go to Build Settings
3. Find "Framework Search Paths"
4. Add `$(SRCROOT)`

### If tests fail with connection message mismatch:
1. Review the `ConnectionViewModel.updateCommonState()` method 
2. Update test expectations to match the actual message strings

### If you encounter build errors:
1. Make sure the main app target builds successfully first
2. Check that all required files are included in the test target

## Note on Test Organization:
- The `MockConnectionService` is used to simulate iPhone connection/disconnection
- `ServiceProvider.shared` is used to inject the mock service
- Tests validate both connection state and user-facing messages 