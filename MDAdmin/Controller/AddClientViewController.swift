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

    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var clientPhoto: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var patronymicField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var birthdayTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        clientPhoto.layer.cornerRadius = 64
        
        registerForKeyboardNotifications()
        
        
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        birthdayTextField.inputView = datePicker
        
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        let some = Int(datePicker.date.timeIntervalSince1970)
        birthdayTextField.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(some)))
        
    }
    
    @IBAction func didPressSetPhoto(_ sender: UIButton) {
        showSimpleActionSheet()        
    }
    
    @IBAction func didPressAddPhoto(_ sender: UIButton) {
        showSimpleActionSheet()
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReadyNewClient" {
            if let destination = segue.destination as? ReadyViewController {
                destination.dataFromNewClient = info
            }
        }
    }
    
    //Mark: - alert when text filed is empty
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressAddClient(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid

        nameField.resignFirstResponder()
        surnameField.resignFirstResponder()
        patronymicField.resignFirstResponder()
        
        let nameEntered = nameField.text ?? ""
        let surnameEntered = surnameField.text ?? ""
        let patronymicEntered = patronymicField.text ?? ""
        let emailEntered = emailTextField.text ?? ""
        var birthdayEntered = Int(birthdayTextField.text ?? "") ?? 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date = dateFormatter.date(from: birthdayTextField.text ?? "")?.timeIntervalSince1970
        
        birthdayEntered = Int(date ?? 0)
        
        //Mark: - Making new client With class Clint (class can be deleted)
        //Mark: - no email checking
        if !nameEntered.isEmpty && !surnameEntered.isEmpty && !patronymicEntered.isEmpty && clientPhoto.image != nil && birthdayEntered != 0 {
            
            let client = Client(name: nameEntered,
                                surname: surnameEntered,
                                patronymic: patronymicEntered,
                                email: emailEntered,
                                birthday: birthdayEntered,
                                imageURL: "",
                                procedures: [])
            
            let clientInitials = client.makeInitials()
            let clinetInitialsWithoutSpacing = client.makeInitialsWithoutSpace()
            
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            //Mark: - making new client imageUrl with name: "\(uid)_\(clinetInitialsWithoutSpacing)"
            pickUnicalClientImageUrl(clientInitials: clientInitials, initialsWithoutSpacing: clinetInitialsWithoutSpacing, photoFromClient: clientPhoto.image ?? UIImage())

            //Mark: - client configuration which will be downloaded to server
            let clientConfiguration: [String: Any] = [
                                                "surname": String(client.surname),
                                                "name": String(client.name),
                                                "patronymic": String(client.patronymic),
                                                "email": String(client.email),
                                                "birthday": Int(client.birthday),
                                                "imageURL": ""
            ]
            
            info = "\(uid ?? " ")/clients/\(clientInitials)"
            ref.child(info).setValue(clientConfiguration)
        } else {
            showAlert()
        }
        
    }
    
    
    
    func showSimpleActionSheet() {
        //let alert = UIAlertController(title: "Выберите", message: "Камера или Галерея", preferredStyle: .actionSheet)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Снять фото", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            //self.addPhotoButton.isHidden = true

            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Выбрать фото", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            //self.addPhotoButton.isHidden = true

            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    
   
    
    func pickUnicalClientImageUrl(clientInitials: String, initialsWithoutSpacing: String, photoFromClient: UIImage){
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference().child("\(uid ?? "errorPicture")_\(initialsWithoutSpacing).jpg")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var result: String?
        //let uploadData = photoFromClient.pngData()
        //let uploadData = photoFromClient.jpegData(compressionQuality: 0.8)
        if let uploadData = photoFromClient.jpegData(compressionQuality: 1) {
        
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
                    ref.child("\(uid ?? " ")/clients/\(clientInitials)/imageURL").setValue(String(result ?? ""))
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
            self.addPhotoButton.setTitle("", for: .normal)
            clientPhoto.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


//Mark: - keyboard slide scroll view
extension AddClientViewController {
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
}
