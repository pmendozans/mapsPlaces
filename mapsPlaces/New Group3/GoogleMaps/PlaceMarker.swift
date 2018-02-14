//
//  PlaceMarker
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import GoogleMaps
import Kingfisher

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        position = place.coordinate
        if let iconUrl = place.iconUrl {
            KingfisherManager.shared.retrieveImage(with: iconUrl, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                self.icon = image?.scale(toSize: CGSize(width: 20, height: 20))
            })
        }
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
