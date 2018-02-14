//
//  GooglePlacesRouter.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import Alamofire

enum GooglePlacesRouter: URLRequestConvertible {
    
    static let baseUrlString = "https://maps.googleapis.com"
    
    case getNearvyPlaces(latitude: Double, longitude: Double)
    
    var method: HTTPMethod {
        switch self {
        case .getNearvyPlaces:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getNearvyPlaces:
            return "maps/api/place/nearbysearch/json"
        }
    }
    
    var params: [String: Any] {
        switch self {
        case .getNearvyPlaces(let latitude, let longitude):
            return [
                "location": "\(latitude),\(longitude)",
                "radius": 1000,
                "rankby": "prominence",
                "sensor": true,
                "types": "food",
                "key": GoogleConfiguration.webKey
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try GooglePlacesRouter.baseUrlString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        switch self {
        case .getNearvyPlaces:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}
