//
//  CustomIOSMarker.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/16/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import MapKit

class CustomIOSMarker: MKMarkerAnnotationView {

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        addDummyView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addDummyView() {
        let view = UIView(frame: self.frame)
        view.backgroundColor = UIColor.blue
        self.addSubview(view)
    }
}
