//
//  MPAlerts.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import LKAlertController

enum CustomAlert {
    static let turnOnLocation = ActionSheet(message: NSLocalizedString("turn-on-location", comment: "")).addAction(NSLocalizedString("cancel", comment: ""))
}
