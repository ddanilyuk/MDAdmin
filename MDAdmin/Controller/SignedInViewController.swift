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
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let email = Auth.auth().currentUser?.email else { return }
        emailOU.text = email
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let email = Auth.auth().currentUser?.email else { return }
        emailOU.text = email
    }

    
    
    
    @IBAction func didPressExit(_ sender: UIButton) {

        do {
            Settings.shared.isLoggedIn = false
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            
            emailOU.text = "email:"
            ViewManager.shared.setupInitialController()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    

}
