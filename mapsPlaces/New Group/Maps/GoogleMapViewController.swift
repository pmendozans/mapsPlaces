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
        placesMapDelegate = self
        setupMapToDefaultlocation()
    }

    private func setupMapToDefaultlocation() {
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 29.097, longitude: -111.022, zoom: 13.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
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

// MARK: PlacesMapDelegate
extension GoogleMapViewController: PlacesMapDelegate{
    
    func placesMap(centerToLocation location: CLLocation) {
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
    }
    
    func placesMap(setMarkers markers: [GooglePlace]) {
        for place in markers {
            let marker = PlaceMarker(place: place)
            marker.map = self.mapView
        }
    }
    
    func placesMap(setMapTypeByIndex index: UInt) {
        guard let mapType = GMSMapViewType(rawValue: index) else {
            return
        }
        mapView.mapType = mapType
    }
}

