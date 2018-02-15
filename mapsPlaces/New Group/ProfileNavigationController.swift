//
//  ProfileNavigationController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addImageToNButton(_ image: UIImage){
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        //imageView.image = resizeImage(image: image, newWidth: 40).withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20.0
        imageView.layer.masksToBounds = true
        let barButton = UIBarButtonItem(customView: imageView)
        barButton.width = 40
        //barButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.openProfile(sender:))))
        self.navigationItem.setRightBarButton(barButton, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
