//
//  AddViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class AddClientViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var clientPhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var patronymicField: UITextField!
    
    @IBAction func didPressSetPhoto(_ sender: UIButton) {
        showSimpleActionSheet()        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Enter all, please", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddClient(_ sender: UIButton) {
        let nameEntered = nameField.text!
        let surnameEntered = surnameField.text!
        let patronymicEntered = patronymicField.text!
        
        if !nameEntered.isEmpty && !surnameEntered.isEmpty && !patronymicEntered.isEmpty {
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            let client = Clients(name: nameEntered, surname: surnameEntered, patronymic: patronymicEntered)
            let clientInitials = client.makeInitials()
            print(clientInitials)
            
            let uid = Auth.auth().currentUser?.uid
            
            let clientConfiguration: [String: String] = [
                                                "surname": String(client.getSurname()),
                                                "name": String(client.getName()),
                                                "patronymic": String(client.getPatronymic())
            ]
            
            ref.child("\(uid ?? " ")/clinets/\(clientInitials)").setValue(clientConfiguration)

        } else {
            showAlert()
        }
        
    }
    
    
    
    func showSimpleActionSheet() {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            print("User click Approve button")
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { (_) in
            print("User click Edit button")
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientPhoto.layer.cornerRadius = 64
        
    }
    
}

extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Here will be info->", info)
        clientPhoto.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
