//
//  MapsHelper.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import UIKit

class MapHelper {
    
    func createMarkerView(googlePlace: GooglePlace) -> UIView {
        let viewWrapper = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
        let infoView = Bundle.main.loadNibNamed("PlaceInformation", owner: nil, options: nil)?.first as! PlaceInformationView
        infoView.translatesAutoresizingMaskIntoConstraints = true
        infoView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        infoView.frame = viewWrapper.bounds
        viewWrapper.addSubview(infoView)
        infoView.loadInformationInView(placeInformation: googlePlace)
        return viewWrapper
    }
}
