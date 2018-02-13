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

class LoginViewController: UIViewController {
    
    let authenticationManager = AuthenticationManager()
    let loginToMapsSegue = "loginToMapsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleLogin()
    }
    
    func setupGoogleLogin() {
        GIDSignIn.sharedInstance().delegate = self
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
            print(error.localizedDescription)
        }
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

extension LoginViewController : GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        authenticationManager.authenticate(withCredential: credential)
        .then { user in
            self.performSegue(withIdentifier: self.loginToMapsSegue, sender: nil)
        }
        .catch { error in
            print(error.localizedDescription)
        }
        
    }
}
