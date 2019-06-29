//
//  LoginViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/28/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            ViewManager.shared.toMainVC()
        }

    }
}
