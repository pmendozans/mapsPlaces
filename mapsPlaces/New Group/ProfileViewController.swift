//
//  ProfileNavigationController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileButton()
    }
    
    func addProfileButton(){
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "user-icon"), style: .plain, target: self, action: #selector(profileTapped))
        barButton.tintColor = UIColor.darkGray
        navigationItem.setRightBarButton(barButton, animated: false)
    }
    
    @objc func profileTapped(){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        guard let profileViewController = storyboard.instantiateInitialViewController() else {
            return
        }
        present(profileViewController, animated: true, completion: nil)
    }
}
