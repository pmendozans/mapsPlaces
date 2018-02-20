//
//  ProfileNavigationController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyUserDefaults

protocol PlacesMapDelegate {
    func placesMap(setMapTypeByIndex index: UInt)
    func placesMap(centerToLocation location: CLLocation)
    func placesMap(setMarkers markers: [GooglePlace])
}

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var placesMapDelegate: PlacesMapDelegate?
    private let googlePlacesViewModel = GooglePlacesViewModel()
    private var didAskedForSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileButton()
        startLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setMapType()
    }
    
    private func setMapType() {
        let mapTypeIndex = UInt(Defaults[.mapTypeIndex])
        delegate?.placesMap(setMapTypeByIndex: mapTypeIndex)
    }
    
    func addProfileButton(){
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user-icon"), style: .plain, target: self, action: #selector(profileTapped))
        barButton.tintColor = UIColor.darkGray
        navigationItem.setRightBarButton(barButton, animated: false)
    }
    
    @objc func profileTapped(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let profileViewController = storyboard.instantiateInitialViewController() else {
            return
        }
        present(profileViewController, animated: true, completion: nil)
    }
    
    @objc private func willEnterForeground(_ notification: NSNotification!) {
        startLocationManager()
    }
    
    private func startLocationManager() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
            if !didAskedForSettings{
                MPAlerts.requestForLocationAlert.show()
                didAskedForSettings = true
            }
        }
        locationManager.startUpdatingLocation()
    }
    
    func openDetailsViewController(place: GooglePlace) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "PlaceDetailsViewController") as! PlaceDetailsViewController
        detailsViewController.googlePlace = place
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        googlePlacesViewModel.getNearvyPlaces(byLocation: coordinate)
            .then { places in
                self.delegate?.placesMap(setMarkers: places)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        //mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        delegate?.placesMap(centerToLocation: location)
        fetchNearbyPlaces(coordinate: location.coordinate)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        MPAlerts.cantGetLocation.show()
    }
}
