//
//  NavigationManager.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/15/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class NavigationManager {
    
    func navigateToLogin() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.window?.rootViewController = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
    }
    
    func navigateToMapsIfLogged() {
        let app = UIApplication.shared.delegate as! AppDelegate
        if Defaults[.isLoggedIn] {
            let mapsNavigator = UIStoryboard(name: "Maps", bundle: nil)
            app.window?.rootViewController = mapsNavigator.instantiateInitialViewController()
            app.window?.makeKeyAndVisible()
        }
    }
}
