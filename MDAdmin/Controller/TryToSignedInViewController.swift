//
//  TryToSignedInViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/25/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class TryToSignedInViewController: UIViewController, GIDSignInUIDelegate {

    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
        if userDefault.bool(forKey: "userSignedIn") {
            //self.dismiss(animated: true, completion: nil)
            navigationController?.popViewController(animated: true)
            //performSegue(withIdentifier: "sequeToSignIn", sender: self)
            //dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if userDefault.bool(forKey: "userSignedIn") {
            navigationController?.popViewController(animated: true)
            //self.dismiss(animated: true, completion: nil)
            //performSegue(withIdentifier: "sequeToSignIn", sender: self)
            //dismiss(animated: true, completion: nil)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
