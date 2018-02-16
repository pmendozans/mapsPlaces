//
//  ProfileNavigationController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import CoreLocation

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    private var didAskedForSettings = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileButton()
        startLocationManager()
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
}
