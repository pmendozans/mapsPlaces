//
//  GoogleMapsViewModel.swift
//  mapsPlaces
//
//  Created by Pablo Arturo Ruiz Mendoza on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import PromiseKit
import CoreLocation
import SwiftyJSON

class GooglePlacesViewModel {
    
    private let googlePlacesSwrvice = GooglePlacesService()
    private let googlePlacesDecoder = GooglePlacesDecoder()
    
    func getNearvyPlaces(byLocation location: CLLocationCoordinate2D) -> Promise<[GooglePlace]> {
        return googlePlacesSwrvice.getNearvyPlaces(byLocation: location)
                .then { responseJson in
                    return self.googlePlacesDecoder.decodePlaceList(dictionaryResponse: responseJson)
                }
    }
}
