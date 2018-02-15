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
    private let googlePlacesViewModel = GooglePlacesViewModel()
    private let mapHelper = MapHelper()
    private let requestForLocationAlert = ActionSheet(message: NSLocalizedString("turn-on-location", comment: ""))
                                            .addAction(NSLocalizedString("cancel", comment: ""))
                                            .addAction(NSLocalizedString("open-settings", comment: ""), style: UIAlertActionStyle.default) { action in
                                                if let url = URL(string:UIApplicationOpenSettingsURLString) {
                                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                                }
                                             }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        startLocationManager()
        setupMapToDefaultlocation()
    }
    
    @objc private func willEnterForeground(_ notification: NSNotification!) {
        startLocationManager()
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
    
    private func startLocationManager() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
            if !didAskedForSettings{
                requestForLocationAlert.show()
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
    
    private func openDetailsViewController(place: GooglePlace) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "PlaceDetailsViewController") as! PlaceDetailsViewController
        detailsViewController.googlePlace = place
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension GoogleMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            fetchNearbyPlaces(coordinate: mapView.camera.target)
        }
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
