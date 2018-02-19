//
//  IosMapViewController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import SwiftyUserDefaults
import LKAlertController

class NativeMapViewController: MapViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let googlePlacesViewModel = GooglePlacesViewModel()
    private let initialLocation = CLLocation(latitude: 29.097, longitude: -111.022)
    private let regionRadius: CLLocationDistance = 1000
    private let mapAnnotationIdentifier = "googlePlace"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        centerMapOnLocation(location: initialLocation)
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
        map.mapType = .standard
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        googlePlacesViewModel.getNearvyPlaces(byLocation: coordinate)
            .then { places -> Void in
                for place in places {
                    self.mapView.addAnnotation(place)
                }
        }
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func useExistingAnotationView(annotation: GooglePlace) -> MKMarkerAnnotationView{
        var annotationView: MKMarkerAnnotationView
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: mapAnnotationIdentifier)
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        if let iconUrl = annotation.iconUrl {
            KingfisherManager.shared.retrieveImage(with: iconUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                annotationView.glyphImage = image?.scale(toSize: CGSize(width: 20, height: 20))
            })
        }
        return annotationView
    }
}

// MARK: - CLLocationManagerDelegate
extension NativeMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        centerMapOnLocation(location: location)
        fetchNearbyPlaces(coordinate: location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - MKMapViewDelegate
extension NativeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? GooglePlace else {
            return nil
        }

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: mapAnnotationIdentifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            return dequeuedView
        }
        return useExistingAnotationView(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let place = view.annotation as? GooglePlace else {
            return
        }
        openDetailsViewController(place: place)
    }
}
