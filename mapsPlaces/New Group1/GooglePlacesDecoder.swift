//
//  GenericDecoder.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import SwiftyJSON
import PromiseKit

class GooglePlacesDecoder {
    
    func decodePlaceList(dictionaryResponse: [String: Any]) -> Promise<[GooglePlace]> {
        return Promise { fullfill, reject in
            let json = JSON(dictionaryResponse)
            guard let placesArray = json["results"].array else {
                let incorrectFormatError = CustomError(message: "Incorrect Format Error")
                reject(incorrectFormatError.createCustomError())
                return
            }
            var placesList: [GooglePlace] = []
            for place in placesArray {
                let foodPlace = GooglePlace(json: place)
                placesList.append(foodPlace)
            }
            fullfill(placesList)
        }
    }
}
