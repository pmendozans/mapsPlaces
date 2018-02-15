//
//  PlaceDetailsViewController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import Cosmos
import Kingfisher

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var placeName: UILabel!
    
    var googlePlace: GooglePlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadPlaceDataToViews()
    }
    
    private func loadPlaceDataToViews(){
        ratingStars.rating = googlePlace.rating
        placeName.text = googlePlace.name

        guard !googlePlace.photoReference.isEmpty,
            let imageUrl = GooglePlacesRouter.getPlaceImage(reference: googlePlace.photoReference).urlRequest?.url else {
            placeImage.image = #imageLiteral(resourceName: "restaurant")
            return
        }
        self.placeImage.kf.setImage(with: imageUrl)
    }
}
