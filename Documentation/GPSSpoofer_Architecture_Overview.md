# GPSSpoofer Architecture Overview

This document provides a high-level overview of the GPSSpoofer application architecture.

## Project Structure

The GPSSpoofer project follows a feature-based organization with a layered architecture:

```
GPSSpoofer/
├── App/                    # App-level components
├── Core/                   # Core infrastructure
│   ├── DependencyInjection/
│   └── Protocols/
├── Features/               # Feature modules
│   ├── Connection/         # Connection feature
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   └── Views/
│   ├── Map/                # Map feature
│   │   ├── Models/
│   │   ├── ViewModels/
│   │   └── Views/
│   └── Main/               # Main UI components
├── Services/               # Service implementations
│   ├── DeviceManager/
│   ├── USB/
│   └── USBConnection/
├── Models/                 # Shared models
├── ViewModels/             # Shared view models
└── Views/                  # Shared views
```

## Architectural Patterns

### MVVM (Model-View-ViewModel)

The app follows the MVVM pattern:
- **Models**: Data structures like `Location`, `Route`, and `Waypoint`
- **Views**: SwiftUI components like `MainView`, `ConnectionStatusView`
- **ViewModels**: Classes like `ConnectionViewModel` and `MapViewModel` that expose data to views and handle business logic

### Dependency Injection

Dependency injection is managed through the `ServiceProvider` class, which:
- Acts as a centralized dependency container
- Creates and provides service instances
- Enables easy swapping of implementations for testing

### Protocol-Oriented Design

Services are defined by protocols which:
- Decouple implementation from interface
- Allow for multiple implementations
- Support testing through mock implementations

Key protocols include:
- `ConnectionServiceProtocol`
- `DeviceManagementProtocol`
- `LocationServiceProtocol`
- `USBCommunicationProtocol`

### Reactive Programming

The app leverages Combine for reactive programming:
- Publishers expose data streams (`connectionStatePublisher`)
- View models subscribe to these publishers with `.sink`
- SwiftUI views observe `@Published` properties in view models

## Key Components

### ServiceProvider

- Singleton that provides access to all services
- Lazy initialization of services
- Factory methods for creating view models

### Connection System

- `ConnectionViewModel`: Manages connection state and provides UI-ready data
- `ConnectionServiceProtocol`: Defines connection service interface
- `USBConnectionServiceImpl`: Implements connection service
- `USBConnectionManager`: Handles low-level USB communication

### Map System

- `MapViewModel`: Manages map state and location data
- `LocationServiceProtocol`: Defines location service interface
- `LegacyLocationServiceAdapter`: Adapts legacy code to new interface

## Transitional Architecture

The codebase appears to be in a transition between:

1. **Legacy System**:
   - Uses singletons like `USBConnectionService.shared`
   - Direct dependencies between components
   - Limited testability

2. **New Architecture**:
   - Protocol-based services
   - Dependency injection
   - Better separation of concerns
   - Improved testability

The project maintains backward compatibility through adapters and dual implementations.

## Testing Support

The architecture supports testing through:
- Protocol-based design allowing mock implementations
- Dedicated testing methods in `ServiceProvider`:
  - `setConnectionService()`
  - `setDeviceManager()`
  - `setLocationService()`

## Conclusion

The GPSSpoofer application has a well-structured architecture that follows modern Swift development practices. The transition from a legacy system to a more maintainable, testable architecture is evident in the codebase, with provisions to maintain backward compatibility during the migration. 