//
//  LoginSecondViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/29/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class LoginSecondViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            GIDSignIn.sharedInstance()?.signIn()
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            print("some errors")
            return
        } else {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (result, error) in
                if error == nil {
                    Settings.shared.isLoggedIn = true
                    
                    let userId = user.userID
                    print("User id is \(String(describing: userId))")
                    let idToken = user.authentication.idToken
                    print("Authentication idToken is \(String(describing: idToken))")
                    let fullName = user.profile.name
                    print("User full name is \(String(describing: fullName))")
                    let givenName = user.profile.givenName
                    print("User given profile name is \(String(describing: givenName))")
                    let familyName = user.profile.familyName
                    print("User family name is \(String(describing: familyName))")
                    let email = user.profile.email
                    print("User email address is \(String(describing: email))")
                } else {
                    print(error?.localizedDescription ?? "")
                }
                
            }
            
        }
        
    }
    @IBAction func didPressBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {

    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("dismissing Google SignIn")
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("presenting Google SignIn")
    }

}
