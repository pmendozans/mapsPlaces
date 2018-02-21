//
//  DefaultsKeys+MapKeys.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation

import SwiftyUserDefaults

extension DefaultsKeys {
    static let mapType = DefaultsKey<MPMapType?>("mapTypeIndex")
    static let isLoggedIn = DefaultsKey<Bool>("isLogedIn")
    static let userUid = DefaultsKey<String>("userUid")
}

extension UserDefaults {
    subscript(key: DefaultsKey<MPMapType?>) -> MPMapType? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
