import SwiftUI
import MapKit

/// A reusable map view component using NSViewRepresentable
struct MapView: NSViewRepresentable {
    // MARK: - Properties
    
    /// The region binding for the map
    @Binding var region: MKCoordinateRegion
    
    /// Optional waypoints to display on the map
    var waypoints: [Waypoint] = []
    
    /// Optional route to display on the map
    var route: Route?
    
    /// Handler for when the map is clicked
    var onMapClick: ((CLLocationCoordinate2D) -> Void)?
    
    // MARK: - NSViewRepresentable
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        customizeAttributionButton(mapView)
        
        // Add gesture recognizer for map clicks
        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapClick(_:)))
        mapView.addGestureRecognizer(clickGesture)
        
        return mapView
    }
    
    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Update region if it changed
        if !mapView.region.center.isEqual(to: region.center) ||
           mapView.region.span.latitudeDelta != region.span.latitudeDelta {
            mapView.setRegion(region, animated: true)
        }
        
        // Update annotations
        updateWaypoints(mapView)
        
        // Update route overlay
        updateRouteOverlay(mapView)
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        // MARK: - Properties
        
        var parent: MapView
        
        // MARK: - Initialization
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // MARK: - Map View Delegate
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Update the binding when the user interacts with the map
            parent.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Custom annotation views could be implemented here
            return nil
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = NSColor.systemBlue
                renderer.lineWidth = 4
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // MARK: - Actions
        
        @objc func handleMapClick(_ gestureRecognizer: NSClickGestureRecognizer) {
            guard let mapView = gestureRecognizer.view as? MKMapView else { return }
            
            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            parent.onMapClick?(coordinate)
        }
    }
    
    // MARK: - Private Methods
    
    private func customizeAttributionButton(_ mapView: MKMapView) {
        guard let button = mapView.subviews.compactMap({ $0 as? NSButton }).first else { return }
        
        // Style modifications
        button.alphaValue = 0.6
        button.isBordered = false
        button.font = NSFont.systemFont(ofSize: 9)
        
        // Constraint adjustments
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -8),
            button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -8),
            button.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func updateWaypoints(_ mapView: MKMapView) {
        // Remove existing waypoint annotations
        let existingWaypoints = mapView.annotations.filter { $0 is WaypointAnnotation }
        mapView.removeAnnotations(existingWaypoints)
        
        // Add current waypoints
        let waypointAnnotations = waypoints.map { waypoint -> WaypointAnnotation in
            let annotation = WaypointAnnotation(waypoint: waypoint)
            annotation.coordinate = CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
            return annotation
        }
        
        mapView.addAnnotations(waypointAnnotations)
    }
    
    private func updateRouteOverlay(_ mapView: MKMapView) {
        // Remove existing route overlays
        let routeOverlays = mapView.overlays.filter { $0 is MKPolyline }
        mapView.removeOverlays(routeOverlays)
        
        // Add current route if available
        if let route = route, !route.waypoints.isEmpty {
            let coordinates = route.waypoints.map { 
                CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) 
            }
            
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polyline)
        }
    }
}

// MARK: - Supporting Classes

/// Custom annotation for waypoints
class WaypointAnnotation: NSObject, MKAnnotation {
    let waypoint: Waypoint
    var coordinate: CLLocationCoordinate2D
    var title: String? { waypoint.name }
    var subtitle: String? { "Lat: \(waypoint.latitude), Lon: \(waypoint.longitude)" }
    
    init(waypoint: Waypoint) {
        self.waypoint = waypoint
        self.coordinate = CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
        super.init()
    }
}

// MARK: - Preview

#if DEBUG
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        // Sample default region
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.67, longitude: -122.12),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        return MapView(region: .constant(region))
            .frame(width: 600, height: 400)
    }
}
#endif
