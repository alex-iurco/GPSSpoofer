# GPSSpoofer UML Documentation

This directory contains PlantUML diagrams that help visualize the architecture of the GPSSpoofer project.

## Diagram Files

1. **GPSSpoofer_Architecture.puml** - Full class diagram showing all key classes, interfaces, and their relationships.
2. **GPSSpoofer_ConnectionSequence.puml** - Sequence diagram showing the device connection flow.
3. **GPSSpoofer_ComponentDiagram.puml** - High-level component diagram showing major system components.

## How to View These Diagrams

You'll need to render these PlantUML files to view them as diagrams. Here are several options:

### Option 1: Online PlantUML Editor

1. Visit the [PlantUML Web Server](http://www.plantuml.com/plantuml/uml/)
2. Copy and paste the content of any .puml file into the editor
3. The diagram will render automatically

### Option 2: Using PlantUML Extension in VS Code

1. Install the "PlantUML" extension for VS Code
2. Open any .puml file
3. Right-click and select "Preview Current Diagram" 
   (or use Alt+D on Windows/Linux, Option+D on Mac)

### Option 3: Command Line with PlantUML JAR

If you have PlantUML installed locally:

```bash
plantuml GPSSpoofer_Architecture.puml
```

This will generate a PNG image of the diagram.

## Architecture Overview

The GPSSpoofer project uses a standard MVVM (Model-View-ViewModel) architecture with dependency injection. The key components are:

### Core Components

- **ServiceProvider** - Singleton that provides all services and facilitates dependency injection
- **Core Protocols** - Define interfaces for services to implement

### Services

- **ConnectionService** - Manages USB device connections
- **DeviceManager** - Communicates with connected devices
- **LocationService** - Manages location data and routes

### ViewModels

- **ConnectionViewModel** - Provides connection state data to views
- **MapViewModel** - Provides location and map data to views

### Views

- **MainView** - The main application view
- **ConnectionStatusView** - Shows connection status
- **SidebarView** - Contains controls and status information

## Extending the Diagrams

To update these diagrams as the project evolves:

1. Edit the corresponding .puml file
2. Add new classes, relationships, or components as needed
3. Regenerate the diagram using one of the methods above

The PlantUML syntax is designed to be simple and readable. See the [PlantUML documentation](https://plantuml.com/class-diagram) for more details on syntax and features. 