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
    
    let authenticationMnager = AuthenticationManager()
    let navigationManager = NavigationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInformation()
        mapModeSwitch.isOn = Defaults[.isSateliteEnabled]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //loadUserInformation()
    }
    
    private func loadUserInformation() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        usernameLabel.text = user.displayName
        phoneNumberLabel.text = user.phoneNumber
        emailLabel.text = user.email
        if let profileUrl = user.photoURL {
            profileImage.kf.setImage(with: profileUrl)
        }
    }
    
    @IBAction func mapMode(_ sender: UISwitch) {
        Defaults[.isSateliteEnabled] = sender.isOn
    }
    
    @IBAction func logout(_ sender: Any) {
        authenticationMnager.logout()
        navigationManager.navigateToLogin()
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
