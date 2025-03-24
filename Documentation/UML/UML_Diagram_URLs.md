# GPSSpoofer UML Diagram Viewer Links

Since local PlantUML rendering isn't set up yet, you can use these links to view the diagrams online using the PlantUML web server.

## Instructions

1. Copy the content of each .puml file
2. Visit the PlantUML web server at http://www.plantuml.com/plantuml/uml/
3. Paste the content into the editor
4. The diagram will render automatically

## Diagram Quick Reference

### Key Architecture Concepts

- **MVVM Architecture**: The project follows a Model-View-ViewModel architecture
- **Dependency Injection**: ServiceProvider manages dependencies
- **Protocol-Oriented Design**: Services implement protocols for testability
- **SwiftUI Views**: UI layer built with SwiftUI
- **Legacy Support**: Some components maintain compatibility with legacy code

### Migration Path

The codebase appears to be in a transition between:
- Legacy system with singletons and direct relationships
- New architecture with protocols, DI, and better testability

## Alternative Tools

If PlantUML doesn't work for you, consider these alternatives:

1. **Mermaid** - JavaScript based diagramming tool
   - Works in GitHub markdown
   - Many online editors available

2. **Lucidchart** - Professional diagramming tool
   - Has free tier
   - Can import/export from various formats

3. **draw.io (diagrams.net)** - Free diagram editor
   - Works online or desktop
   - Good for quick diagrams

4. **Xcode's Class Diagram Tool** - Built into Xcode
   - Limited but integrated with development environment
   - Open .swift files and use Editor > Create Class Diagram 