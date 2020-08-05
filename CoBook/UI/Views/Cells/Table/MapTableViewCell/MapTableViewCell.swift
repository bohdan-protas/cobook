//
//  MapTableViewCell.swift
//  CoBook
//
//  Created by protas on 4/7/20.
//  Copyright © 2020 CoBook. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol MapTableViewCellDelegate: class {
    func mapTableViewCell(_ cell: MapTableViewCell, didUpdateVisibleRectBounds topLeft: CLLocationCoordinate2D?, bottomRight: CLLocationCoordinate2D?)
    func openSettingsAction(_ cell: MapTableViewCell)
    func mapTableViewCell(_ cell: MapTableViewCell, didTappedOnMarker marker: GMSMarker)
}

class MapTableViewCell: UITableViewCell {

    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var mapView: GMSMapView!

    /// placehoolder view for showing when location access denied
    lazy var placeholderView: UIView = {
        let view = DeniedAccessToLocationPlaceholderView(frame: self.contentView.bounds)
        view.onOpenSettingsHandler = {
            self.delegate?.openSettingsAction(self)
        }
        return view
    }()

    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var zoomLevel: Float = 10.0

    private var markers: [GMSMarker] = []
    private var isInitialSetup: Bool = true
    weak var delegate: MapTableViewCellDelegate?

    // MARK: - View Object Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 5000
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        mapView.delegate = self

        // Add the map to the view, hide it until we've got a location update.
        mapView.isHidden = true
    }
    
    func setupMarkers(_ markers: [GMSMarker], forceFitCamera: Bool = false) {
        self.markers.forEach { $0.map = nil }
        self.markers = markers
        self.markers.forEach { $0.map = mapView }
        
        if isInitialSetup || forceFitCamera  {
            var bounds = GMSCoordinateBounds()
            for marker in self.markers {
                bounds = bounds.includingCoordinate(marker.position)
            }

            let cameraUpdate = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0 , left: 50.0 ,bottom: 50.0 ,right: 50.0))
            mapView.animate(with: cameraUpdate)
        }

        isInitialSetup = false
    }

}

// MARK: - GMSMapViewDelegate

extension MapTableViewCell: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        delegate?.mapTableViewCell(self, didTappedOnMarker: marker)
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                break
            case .authorizedAlways, .authorizedWhenInUse:
                delegate?.mapTableViewCell(self, didUpdateVisibleRectBounds: mapView.projection.visibleRegion().farLeft, bottomRight: mapView.projection.visibleRegion().nearRight)
            @unknown default:
                break
            }
        } else {
            Log.error("Location services are not enabled")
        }
    }
    
}


// MARK: - CLLocationManagerDelegate

extension MapTableViewCell: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: zoomLevel)

            mapView.isHidden = false
            mapView.camera = camera
        }
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        placeholderView.removeFromSuperview()
        switch status {
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            mapView.isHidden = false
            Log.debug("Location status is OK.")
            break
        case .restricted:
            Log.error("Location access was restricted.")
            fallthrough
        case .denied:
            Log.error("User denied access to location.")
            fallthrough
        case .notDetermined:
            Log.error("Location status not determined.")
            fallthrough
        @unknown default:
            mapView.isHidden = true
            self.contentView.addSubview(placeholderView)
            self.contentView.bringSubviewToFront(placeholderView)
        }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        Log.error("Error: \(error)")
    }


}
