//
//  SignedInViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/25/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class SignedInViewController: UIViewController {
    @IBOutlet weak var emailOU: UILabel!
    @IBOutlet weak var signedInLabel: UILabel!
    @IBOutlet weak var signedInButton: UIButton!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email else { return }
        emailOU.text = email
        if userDefault.bool(forKey: "userSignedIn") {
            signedInLabel.text = "You are signed in"
            signedInButton.isEnabled = false
            //performSegue(withIdentifier: "sequeToSignIn", sender: self)
            //dismiss(animated: true, completion: nil)
        } else {
            signedInLabel?.text = "You are not signed in"
            signedInButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "userSignedIn") {
            signedInLabel.text = "You are signed in"
            signedInButton.isEnabled = false
            //performSegue(withIdentifier: "sequeToSignIn", sender: self)
            //dismiss(animated: true, completion: nil)
        } else {
            signedInLabel?.text = "You are not signed in"
            signedInButton.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let email = Auth.auth().currentUser?.email else { return }
        emailOU.text = email
        if userDefault.bool(forKey: "userSignedIn") {
            signedInButton.isEnabled = false
            signedInLabel.text = "You are signed in"
            
            //performSegue(withIdentifier: "sequeToSignIn", sender: self)
            //dismiss(animated: true, completion: nil)
        } else {
            signedInLabel.text = "You are not signed in"
            signedInButton.isEnabled = true
        }
    }
    
    @IBAction func didPressExit(_ sender: UIButton) {

        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()

            userDefault.removeObject(forKey: "userSignedIn")
            userDefault.synchronize()
            emailOU.text = "email:"
            signedInLabel.text = "You are not signed in"
            signedInButton.isEnabled = true
            //signedInLabel.text = "You are not signed in"
            
            //self.dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
//        let firebaseAuth = Auth.auth()
//        do {
//            try firebaseAuth.signOut()
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
    }
    
    

}
