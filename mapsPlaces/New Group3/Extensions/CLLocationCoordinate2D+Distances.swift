//
//  CLLocationCoordinate2D+Distances.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import CoreLocation

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
