//
//  GoogleMapViewController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import LKAlertController
import SwiftyUserDefaults

class GoogleMapViewController: MapViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var didAskedForSettings = false
    private let googlePlacesViewModel = GooglePlacesViewModel()
    private let mapHelper = MapHelper()
    private var lastFarLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        setupMapToDefaultlocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMapType()
    }
    
    private func setMapType() {
        guard let map = mapView else {
            return
        }
        if Defaults[.isSateliteEnabled] {
            map.mapType = .satellite
            return
        }
        map.mapType = .normal
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        googlePlacesViewModel.getNearvyPlaces(byLocation: coordinate)
        .then { places -> Void in
            for place in places {
                let marker = PlaceMarker(place: place)
                marker.map = self.mapView
            }
        }
    }

    private func setupMapToDefaultlocation() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 29.097, longitude: -111.022, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
    }
}

// MARK: - CLLocationManagerDelegate
extension GoogleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        fetchNearbyPlaces(coordinate: mapView.camera.target)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: GMSMapViewDelegate
extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        let markerView = mapHelper.createMarkerView(googlePlace: placeMarker.place)
        return markerView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let placeMarker = marker as? PlaceMarker else {
            return
        }
        openDetailsViewController(place: placeMarker.place)
    }
}
