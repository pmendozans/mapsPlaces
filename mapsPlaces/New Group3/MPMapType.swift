//
//  MPMapType.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/21/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import GoogleMaps
import MapKit

enum MPMapType: Int {
    case streets = 1
    case satellite
    
    func getGoogleMapsType() -> GMSMapViewType? {
        return GMSMapViewType(rawValue: UInt(rawValue))
    }
    
    func getNativeMapsType() -> MKMapType? {
        return MKMapType(rawValue: UInt(rawValue - 1))
    }
}
