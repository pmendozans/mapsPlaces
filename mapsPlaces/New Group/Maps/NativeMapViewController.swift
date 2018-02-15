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

class NativeMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var didAskedForSettings = false
    private let locationManager = CLLocationManager()
    private let googlePlacesViewModel = GooglePlacesViewModel()
    private let initialLocation = CLLocation(latitude: 29.097, longitude: -111.022)
    private let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        startLocationManager()
        centerMapOnLocation(location: initialLocation)
    }
    
    @objc private func willEnterForeground(_ notification: NSNotification!) {
        startLocationManager()
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        googlePlacesViewModel.getNearvyPlaces(byLocation: coordinate)
            .then { places -> Void in
                for place in places {
                    //let marker = PlaceMarker(place: place)
                    self.mapView.addAnnotation(place)
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
                //requestForLocationAlert.show()
                didAskedForSettings = true
            }
        }
        locationManager.startUpdatingLocation()
    }
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func openDetailsViewController(place: GooglePlace) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "PlaceDetailsViewController") as! PlaceDetailsViewController
        detailsViewController.googlePlace = place
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension NativeMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            centerMapOnLocation(location: location)
            fetchNearbyPlaces(coordinate: location.coordinate)
        }
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
        let identifier = "googlePlace"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
            view.image = nil
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            if let iconUrl = annotation.iconUrl {
                KingfisherManager.shared.retrieveImage(with: iconUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                    view.glyphImage = image?.scale(toSize: CGSize(width: 20, height: 20))
                })
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let place = view.annotation as? GooglePlace else {
            return
        }
        openDetailsViewController(place: place)
    }
}
