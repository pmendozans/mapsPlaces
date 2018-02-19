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
    
    private let nibName = "PlaceInformation"
    
    func createMarkerView(googlePlace: GooglePlace) -> UIView {
        let viewWrapper = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 50))
        let infoView = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as! PlaceInformationView
        infoView.frame = viewWrapper.bounds
        viewWrapper.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: viewWrapper.topAnchor, constant: 0),
            infoView.bottomAnchor.constraint(equalTo: viewWrapper.bottomAnchor, constant: 0),
            infoView.leftAnchor.constraint(equalTo: viewWrapper.leftAnchor, constant: 0),
            infoView.rightAnchor.constraint(equalTo: viewWrapper.rightAnchor, constant: 0)
            ])
        infoView.loadInformationInView(placeInformation: googlePlace)
        return viewWrapper
    }
}
