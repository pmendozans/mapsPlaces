//
//  GoogleMapsService.swift
//  mapsPlaces
//
//  Created by Pablo Arturo Ruiz Mendoza on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import PromiseKit
import CoreLocation

class GooglePlacesService {
    
    private let apiManager = ApiManager()
    
    func getNearvyPlaces(byLocation location: CLLocationCoordinate2D) -> Promise<[String: Any]> {
        let placesRequest = GooglePlacesRouter.getNearvyPlaces(latitude: location.latitude, longitude: location.longitude)
        return apiManager.genericRequest(request: placesRequest)
    }
}
