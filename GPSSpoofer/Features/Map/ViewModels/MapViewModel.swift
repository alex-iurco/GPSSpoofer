import Foundation
import MapKit
import Combine

/// ViewModel that manages map state and interactions
class MapViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The region shown on the map
    @Published var region: MKCoordinateRegion
    
    /// The selected location, if any
    @Published var selectedLocation: Location?
    
    /// The list of waypoints to display on the map
    @Published var waypoints: [Waypoint] = []
    
    /// The current route, if any
    @Published var currentRoute: Route?
    
    /// Whether the map is in edit mode
    @Published var isEditMode: Bool = false
    
    // MARK: - Private Properties
    
    /// The location service that provides location data
    private let locationService: LocationServiceProtocol?
    
    /// Cancellable subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Default initializer for backward compatibility
    init() {
        // Default to Redmond, WA area
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.67, longitude: -122.12),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.locationService = nil
    }
    
    /// Initializer that uses the new location service protocol
    /// - Parameter locationService: The location service to use
    init(locationService: LocationServiceProtocol) {
        // Default to Redmond, WA area
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 47.67, longitude: -122.12),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        self.locationService = locationService
        setupLocationBindings()
    }
    
    // MARK: - Public Methods
    
    /// Sets the map region to the specified coordinates
    /// - Parameters:
    ///   - latitude: The latitude
    ///   - longitude: The longitude
    ///   - span: The zoom level, expressed as a coordinate span
    func setRegion(latitude: Double, longitude: Double, span: MKCoordinateSpan? = nil) {
        let mapSpan = span ?? MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: mapSpan
        )
        
        // Update location service if available
        if let locationService = locationService {
            locationService.setLocation(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
    }
    
    /// Centers the map on a location
    /// - Parameter location: The location to center on
    func centerOn(location: Location) {
        setRegion(latitude: location.latitude, longitude: location.longitude)
    }
    
    /// Adds a waypoint to the map
    /// - Parameter waypoint: The waypoint to add
    func addWaypoint(_ waypoint: Waypoint) {
        waypoints.append(waypoint)
    }
    
    /// Creates and adds a waypoint at the specified coordinate
    /// - Parameters:
    ///   - coordinate: The coordinate for the waypoint
    ///   - name: Optional name for the waypoint
    /// - Returns: The created waypoint
    @discardableResult
    func addWaypoint(at coordinate: CLLocationCoordinate2D, name: String = "Waypoint") -> Waypoint {
        let waypoint = Waypoint(name: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
        waypoints.append(waypoint)
        return waypoint
    }
    
    /// Removes a waypoint from the map
    /// - Parameter waypoint: The waypoint to remove
    func removeWaypoint(_ waypoint: Waypoint) {
        waypoints.removeAll { $0.id == waypoint.id }
    }
    
    /// Sets the current route
    /// - Parameter route: The route to display
    func setRoute(_ route: Route?) {
        currentRoute = route
    }
    
    /// Clears all waypoints and routes from the map
    func clearMap() {
        waypoints = []
        currentRoute = nil
    }
    
    /// Toggles edit mode on/off
    func toggleEditMode() {
        isEditMode.toggle()
    }
    
    // MARK: - Private Methods
    
    /// Sets up bindings to the location service
    private func setupLocationBindings() {
        guard let locationService = locationService else { return }
        
        locationService.currentLocationPublisher
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coordinate in
                guard let self = self else { return }
                // Only update if the coordinates are significantly different
                if self.region.center.latitude.distance(to: coordinate.latitude) > 0.0001 ||
                   self.region.center.longitude.distance(to: coordinate.longitude) > 0.0001 {
                    self.region = MKCoordinateRegion(
                        center: coordinate,
                        span: self.region.span
                    )
                }
            }
            .store(in: &cancellables)
    }
}
