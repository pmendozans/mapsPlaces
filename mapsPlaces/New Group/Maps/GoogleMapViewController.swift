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

class GoogleMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var didAskedForSettings = false
    private let locationManager = CLLocationManager()
    private let dataProvider = GoogleDataProvider()
    private var searchedTypes = ["bar", "cafe", "restaurant"]
    private let searchRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        startLocationManager()
        setupMapToDefaultlocation()
    }
    
    @objc private func willEnterForeground(_ notification: NSNotification!) {
        startLocationManager()
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
    
    private func startLocationManager() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
            if !didAskedForSettings{
                ActionSheet(message: NSLocalizedString("turn-on-location", comment: ""))
                    .addAction(NSLocalizedString("cancel", comment: ""))
                    .addAction(NSLocalizedString("open-settings", comment: ""), style: UIAlertActionStyle.default) { action in
                        if let url = URL(string:UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    .show()
                didAskedForSettings = true
            }
            
        }
        locationManager.startUpdatingLocation()
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
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            fetchNearbyPlaces(coordinate: mapView.camera.target)
            GoogleMapsService().getNearvyPlaces(byLocation: (locations.first?.coordinate)!)
            //locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
