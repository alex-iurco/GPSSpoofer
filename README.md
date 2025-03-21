# GPS Spoofer

A macOS application designed to simulate GPS locations for iOS devices during development and testing.

## Features

- Connect to iOS devices via USB
- Spoof GPS coordinates (latitude, longitude, altitude)
- Real-time location updates
- Clean, native macOS interface
- Simple and intuitive controls

## Requirements

- macOS 12.0 or later
- Xcode 13.0 or later
- iOS device for testing

## Installation

1. Clone the repository:
```bash
git clone https://github.com/alex-iurco/GPSSpoofer.git
```

2. Open the project in Xcode:
```bash
cd GPSSpoofer
open GPSSpoofer.xcodeproj
```

3. Build and run the project (⌘R)

## Usage

1. Connect your iOS device via USB
2. Launch the GPS Spoofer application
3. Click "Connect" to establish connection with your device
4. Enter the desired coordinates:
   - Latitude (-90 to 90)
   - Longitude (-180 to 180)
   - Altitude (in meters)
5. Click "Update Location" to send the new coordinates

## Development

The project is built using:
- Swift 5
- SwiftUI
- Apple's DeviceLink framework for iOS device communication

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see below for why this license was chosen. 