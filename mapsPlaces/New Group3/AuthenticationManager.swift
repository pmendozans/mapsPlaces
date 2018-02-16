//
//  FacebookLoginManager.swift
//  mapsPlaces
//
//  Created by Pablo Ruiz on 2/13/18.
//  Copyright © 2018 nearsoft. All rights reserved.
//

import Foundation
import PromiseKit
import FacebookLogin
import FacebookCore
import Firebase
import SwiftyUserDefaults

class AuthenticationManager {
    
    private let dataManager = UserDataManager()
    
    func loginWithFacebook() -> Promise<AuthCredential> {
        return Promise { fullfill, reject in
            let facebookLoginManager = LoginManager()
            facebookLoginManager.logIn(readPermissions:[.publicProfile, .email], viewController: nil) { loginResult in
                switch loginResult {
                case .failed(let error):
                    reject(error)
                case .cancelled:
                    let customError = CustomError(message: "User cancelled Facebook login")
                    reject(customError.createCustomError())
                case .success(_,_,let token):
                    let credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                    fullfill(credential)
                }
            }
        }
    }
    
    func authenticate(withCredential credential: AuthCredential) -> Promise<User> {
        return Promise { fullfill, reject in
            Auth.auth().signIn(with: credential) { user, error in
                if let error = error {
                    reject(error)
                    return
                }
                guard let user = user else {
                    let customError = CustomError(message: "Could not get user information after login")
                    reject(customError.createCustomError())
                    return
                }
                Defaults[.isLoggedIn] = true
                Defaults[.userUid] = user.uid
                self.dataManager.saveUserIfNotExists(user: user)
                fullfill(user)
            }
        }
    }
    
    func logout() {
        do {
            Defaults[.isLoggedIn] = false
            try Auth.auth().signOut()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
