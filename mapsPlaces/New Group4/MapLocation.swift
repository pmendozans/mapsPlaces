//
//  MapLocation.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON
import ObjectMapper

class MapLocation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String? = ""
    var subtitle: String? = ""
    
    init(json: JSON) {
        let lat = json["geometry"]["location"]["lat"].doubleValue as CLLocationDegrees
        let lng = json["geometry"]["location"]["lng"].doubleValue as CLLocationDegrees
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        title = json["name"].stringValue
        subtitle = ""
        super.init()
    }
}
