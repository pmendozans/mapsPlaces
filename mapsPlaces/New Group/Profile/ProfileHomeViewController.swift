//
//  ProfileHomeViewController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/14/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftyUserDefaults

class ProfileHomeViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var mapModeSwitch: UISwitch!
    @IBOutlet weak var streetsImage: UIImageView!
    @IBOutlet weak var satelliteImage: UIImageView!
    
    private let authenticationMnager = AuthenticationManager()
    private let navigationManager = NavigationManager()
    private let userDataManager = UserDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInformation()
        mapModeSwitch.isOn = Defaults[.mapTypeIndex] == 1
        updateImagesAlpha()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserInformation()
    }
    
    private func loadUserInformation() {
        guard let localUser = userDataManager.fetchUser(byUid: Defaults[.userUid]) else {
            return
        }
        usernameLabel.text = localUser.username
        phoneNumberLabel.text = localUser.phoneNumber
        emailLabel.text = localUser.email
        if let profileUrl = localUser.imageUrl {
            profileImage.kf.setImage(with: profileUrl, placeholder: profileImage.image)
        }
    }
    
    private func updateImagesAlpha() {
        UIView.animate(withDuration: 0.4, animations: {
            self.streetsImage.alpha = self.mapModeSwitch.isOn ? 0.2 : 1
            self.satelliteImage.alpha = self.mapModeSwitch.isOn ? 1 : 0.2
        })
    }
    
    @IBAction func mapMode(_ sender: UISwitch) {
        Defaults[.mapTypeIndex] = sender.isOn ? 1 : 2
        updateImagesAlpha()
    }
    
    @IBAction func logout(_ sender: Any) {
        authenticationMnager.logout()
        navigationManager.navigateToLogin()
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
