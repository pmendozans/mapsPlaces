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
        placesMapDelegate = self
        centerMapOnLocation(location: initialLocation)
    }
        
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
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

// MARK: - PlacesMapDelegate
extension NativeMapViewController: PlacesMapDelegate{
    func placesMap(centerToLocation location: CLLocation) {
        centerMapOnLocation(location: location)
    }
    
    func placesMap(setMarkers markers: [GooglePlace]) {
        for marker in markers {
            self.mapView.addAnnotation(marker)
        }
    }
    
    func placesMap(setMapTypeByIndex index: UInt) {
        guard let mapType = MKMapType(rawValue: index - 1) else {
            return
        }
        mapView.mapType = mapType
    }
}
