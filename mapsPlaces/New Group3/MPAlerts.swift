//
//  MPAlerts.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/16/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import LKAlertController

enum MPAlerts {
    static let loginError = Alert(message: NSLocalizedString("login-error", comment: "")).addAction("Ok")
    static let cantOpenLibrary = Alert(message: NSLocalizedString("cant-open-library", comment: "")).addAction("Ok")
    static let requestForLocationAlert = ActionSheet(message: NSLocalizedString("turn-on-location", comment: ""))
                                        .addAction(NSLocalizedString("cancel", comment: ""))
                                        .addAction(NSLocalizedString("open-settings", comment: ""), style: UIAlertActionStyle.default, handler: {_ in
                                            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            }
                                        })

}
