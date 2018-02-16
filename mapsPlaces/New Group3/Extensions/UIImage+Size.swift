//
//  UIImage+Size.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func scale(toSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        draw(in: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: newSize.width, height: newSize.height))  )
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
