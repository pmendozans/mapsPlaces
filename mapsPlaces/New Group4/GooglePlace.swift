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

class GooglePlace {
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var rating: Double
    var photo: UIImage?
    var iconUrl: URL?
    
    init(json: JSON)
    {
        name = json["name"].stringValue
        address = json["vicinity"].stringValue
        let lat = json["geometry"]["location"]["lat"].doubleValue
        let lng = json["geometry"]["location"]["lng"].doubleValue
        rating = json["rating"].doubleValue
        coordinate = CLLocationCoordinate2DMake(lat, lng)
        let iconUrlString = json["icon"].stringValue
        iconUrl = URL(string: iconUrlString)
    }
}
