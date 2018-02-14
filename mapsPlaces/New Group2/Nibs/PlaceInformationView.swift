//
//  PlaceDetailsView.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit

class PlaceInformationView: UIView {
    
    @IBOutlet weak var placePhotoImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var viewDetailsButton: UIButton!
    
    var buttonAction: (() -> Void)?
    
    func loadInformationInView(placeInformation: GooglePlace) {
        placeNameLabel.text = placeInformation.name
    }
    
    @IBAction func viewWasTapped(_ sender: Any) {
        if let action = buttonAction {
            action()
        }
    }
}
