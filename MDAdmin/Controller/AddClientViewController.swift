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
    var info: String = ""

    @IBOutlet weak var clientPhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var patronymicField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientPhoto.layer.cornerRadius = 64
        registerForKeyboardNotifications()
        self.hideKeyboard()
    }
    
    @IBAction func didPressSetPhoto(_ sender: UIButton) {
        showSimpleActionSheet()        
    }
    

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @objc func kbWillHide() {
        scrollView.contentOffset = CGPoint.zero
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReadyNewClient" {
            if let destination = segue.destination as? ReadyViewController {
                destination.dataFromNewClient = info
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Enter all, please", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddClient(_ sender: UIButton) {
        nameField.resignFirstResponder()
        surnameField.resignFirstResponder()
        patronymicField.resignFirstResponder()
        
        let nameEntered = nameField.text!
        let surnameEntered = surnameField.text!
        let patronymicEntered = patronymicField.text!
        
        let uid = Auth.auth().currentUser?.uid

        
        //Mark: - Making new client With class Clint (class can be deleted)
        if !nameEntered.isEmpty && !surnameEntered.isEmpty && !patronymicEntered.isEmpty {
            
            let client = Client(name: nameEntered, surname: surnameEntered, patronymic: patronymicEntered)
            
            let clientInitials = client.makeInitials()
            let clinetInitialsWithoutSpacing = client.makeInitialsWithotSpace()
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            //Mark: - making new client imageUrl with name: "\(uid)_\(clinetInitialsWithoutSpacing)"
            pickUnicalClientImageUrl(clientInitials: clientInitials, initialsWithoutSpacing: clinetInitialsWithoutSpacing, photoFromClient: clientPhoto.image ?? UIImage())

            //Mark: - client configuration which will be downloaded to server
            let clientConfiguration: [String: String] = [
                                                "surname": String(client.getSurname()),
                                                "name": String(client.getName()),
                                                "patronymic": String(client.getPatronymic()),
                                                "imageURL": ""
            ]
            ref.child("\(uid ?? " ")/clinets/\(clientInitials)").setValue(clientConfiguration)
            info = "\(uid ?? " ")/clinets/\(clientInitials)"
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
            self.imagePicker.allowsEditing = true

            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { (_) in
            print("User click Edit button")
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true

            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
   
    
    func pickUnicalClientImageUrl(clientInitials: String, initialsWithoutSpacing: String, photoFromClient: UIImage){
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("\(uid ?? "errorPicture")_\(initialsWithoutSpacing).jpg")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var result: String?
        if let uploadData = photoFromClient.jpegData(compressionQuality: 0.5) {
        
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else { return }
                print(metadata)
                if error != nil {
                    print(error?.localizedDescription ?? "SOME ERROR")
                    return
                }
                storageRef.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else { return }
                    result = downloadURL.absoluteString
                    ref.child("\(uid ?? " ")/clinets/\(clientInitials)/imageURL").setValue(String(result ?? ""))
                    // maybe need to know when the image downloaded
                })
            })
        }
    }
}

//Mark: - imagePicker
extension AddClientViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            clientPhoto.image = selectedImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
