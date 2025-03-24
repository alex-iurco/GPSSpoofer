# GPSSpoofer Project Documentation

This directory contains documentation for the GPSSpoofer project, including architecture diagrams, guides, and overviews.

## Contents

### Architecture

- [Architecture Overview](GPSSpoofer_Architecture_Overview.md) - Comprehensive overview of the application architecture

### UML Diagrams

- [Class Diagram](UML/GPSSpoofer_Architecture.puml) - Complete class diagram showing relationships between components
- [Component Diagram](UML/GPSSpoofer_ComponentDiagram.puml) - High-level component diagram
- [Connection Sequence Diagram](UML/GPSSpoofer_ConnectionSequence.puml) - Sequence diagram for device connection process
- [UML Diagram Usage Guide](UML/UML_Diagrams_README.md) - Instructions for using the UML diagrams
- [UML Online Viewer Links](UML/UML_Diagram_URLs.md) - Information on online PlantUML tools

### Guides

- [Xcode Documentation Tips](Guides/Xcode_Documentation_Tips.md) - Guide for using Xcode's built-in documentation tools

## How to View UML Diagrams

To view the UML diagrams:

1. Copy the content of a .puml file
2. Visit the PlantUML web server at http://www.plantuml.com/plantuml/uml/
3. Paste the content into the editor
4. The diagram will render automatically

## Key Architecture Insights

- **MVVM Architecture**: The project follows Model-View-ViewModel design
- **Dependency Injection**: Managed through ServiceProvider
- **Protocol-Oriented Design**: Services implement protocols for better testability
- **Transitional Codebase**: Moving from legacy patterns to modern architecture

## Updating Documentation

When making significant changes to the codebase, consider updating these documentation files to keep them in sync with the actual implementation. 