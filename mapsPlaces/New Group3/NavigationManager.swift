//
//  NavigationManager.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import UIKit

class NavigationManager {
    
    let window = UIApplication.shared.keyWindow
    
    func navigateToLogin() {
        window?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
    }
}
