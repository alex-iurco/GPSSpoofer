import SwiftUI
import MapKit

/// A custom map view implemented with NSViewRepresentable
struct CustomMapView: NSViewRepresentable {
    // MARK: - Properties
    
    /// The binding for the map region
    @Binding var region: MKCoordinateRegion
    
    /// Optional handler for map click events
    var onMapClick: ((CLLocationCoordinate2D) -> Void)?
    
    /// Optional waypoints to display
    var waypoints: [Waypoint] = []
    
    /// Optional route to display
    var route: Route?
    
    // MARK: - NSViewRepresentable
    
    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        
        // Add gesture recognizer for clicking on the map
        let clickGesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleMapClick(_:)))
        mapView.addGestureRecognizer(clickGesture)
        
        return mapView
    }
    
    func updateNSView(_ mapView: MKMapView, context: Context) {
        // Update region if significantly changed
        if !mapView.region.center.isEqual(to: region.center) ||
           mapView.region.span.latitudeDelta != region.span.latitudeDelta {
            mapView.setRegion(region, animated: true)
        }
        
        // Update waypoint annotations
        updateWaypoints(mapView)
        
        // Update route overlay
        updateRouteOverlay(mapView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView
        
        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Update the binding when the user interacts with the map
            DispatchQueue.main.async {
                if !mapView.region.isEqual(to: self.parent.region) {
                    self.parent.region = mapView.region
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? WaypointAnnotation {
                let identifier = "Waypoint"
                
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                // Customize the appearance
                if let markerView = annotationView as? MKMarkerAnnotationView {
                    markerView.markerTintColor = NSColor.systemBlue
                    markerView.glyphText = "\(annotation.index + 1)"
                }
                
                return annotationView
            }
            
            return nil
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = NSColor.systemBlue
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        @objc func handleMapClick(_ gestureRecognizer: NSClickGestureRecognizer) {
            guard let mapView = gestureRecognizer.view as? MKMapView,
                  let onClick = parent.onMapClick else { return }
            
            let point = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            onClick(coordinate)
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateWaypoints(_ mapView: MKMapView) {
        // Remove existing waypoint annotations
        let existingAnnotations = mapView.annotations.filter { $0 is WaypointAnnotation }
        mapView.removeAnnotations(existingAnnotations)
        
        // Add current waypoints
        let waypoints = self.waypoints
        let wayPointAnnotations = waypoints.enumerated().map { index, waypoint -> WaypointAnnotation in
            let annotation = WaypointAnnotation(waypoint: waypoint, index: index)
            return annotation
        }
        
        if !wayPointAnnotations.isEmpty {
            mapView.addAnnotations(wayPointAnnotations)
        }
    }
    
    private func updateRouteOverlay(_ mapView: MKMapView) {
        // Remove existing route overlays
        let routeOverlays = mapView.overlays.filter { $0 is MKPolyline }
        mapView.removeOverlays(routeOverlays)
        
        // Add current route if available
        if let route = route, route.waypoints.count > 1 {
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
    let index: Int
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
    }
    
    var title: String? { waypoint.name }
    var subtitle: String? { "Lat: \(waypoint.latitude), Lng: \(waypoint.longitude)" }
    
    init(waypoint: Waypoint, index: Int) {
        self.waypoint = waypoint
        self.index = index
        super.init()
    }
}

// MARK: - Extensions

extension CLLocationCoordinate2D {
    func isEqual(to other: CLLocationCoordinate2D, precision: Double = 0.000001) -> Bool {
        return abs(latitude - other.latitude) < precision && abs(longitude - other.longitude) < precision
    }
}

extension MKCoordinateRegion {
    func isEqual(to other: MKCoordinateRegion, precision: Double = 0.000001) -> Bool {
        return center.isEqual(to: other.center, precision: precision) &&
               abs(span.latitudeDelta - other.span.latitudeDelta) < precision &&
               abs(span.longitudeDelta - other.span.longitudeDelta) < precision
    }
}
