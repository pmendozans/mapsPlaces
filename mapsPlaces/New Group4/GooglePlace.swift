//
//  PlaceMarker
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON
import MapKit

class GooglePlace: NSObject, MKAnnotation {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var rating: Double
    var photoReference: String
    var iconUrl: URL?
    let title: String?
    
    init(json: JSON)
    {
        name =              json["name"].stringValue
        title =             json["name"].stringValue
        address =           json["vicinity"].stringValue
        photoReference =    json["photos"][0]["photo_reference"].stringValue
        let lat =           json["geometry"]["location"]["lat"].doubleValue
        let lng =           json["geometry"]["location"]["lng"].doubleValue
        rating =            json["rating"].doubleValue
        let iconUrlString = json["icon"].stringValue
        iconUrl = URL(string: iconUrlString)
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
