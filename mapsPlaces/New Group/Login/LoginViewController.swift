//
//  ViewController.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin

class LoginViewController: UIViewController, GIDSignInDelegate {
    
    private let authenticationManager = AuthenticationManager()
    private let loginToMapsSegue = "loginToMapsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleLogin()
    }
    
    func setupGoogleLogin() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        authenticationManager.loginWithFacebook()
        .then { facebookCredential in
            self.authenticationManager.authenticate(withCredential: facebookCredential)
        }
        .then { user in
            self.performSegue(withIdentifier: self.loginToMapsSegue, sender: nil)
        }
        .catch{ error in
            MPAlerts.loginError.show()
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController: GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil, let authentication = user.authentication else {
            MPAlerts.loginError.show()
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        authenticationManager.authenticate(withCredential: credential)
        .then { user in
            self.performSegue(withIdentifier: self.loginToMapsSegue, sender: nil)
        }
        .catch { error in
            MPAlerts.loginError.show()
        }
    }
}
