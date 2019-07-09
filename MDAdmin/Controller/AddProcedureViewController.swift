//
//  AddProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class AddProcedureViewController: UIViewController {
    
    
    @IBOutlet weak var editCostTextField: UITextField!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var clientInitialsLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var procedurePicker: UIPickerView!
    
    //TODO: - NEED TO USE PROCEDURE FROM SETTINGS
    let procedure1 = ListOfProcedures(name: "Процедура1", cost: 100)
    let procedure2 = ListOfProcedures(name: "Процедура2", cost: 200)
    let procedure3 = ListOfProcedures(name: "Процедура3", cost: 300)
    let procedure4 = ListOfProcedures(name: "Процедура4", cost: 400)
    let procedure5 = ListOfProcedures(name: "Процедура5", cost: 500)

    var procedures = [ListOfProcedures]()
    var client = Client()
    let imagePicker = UIImagePickerController()
    var imageBefore = UIImage()
    var imageAfter = UIImage()
    var info: String = ""


    var dateNow = ""
    var dateForUser = ""
    var isTapImageBefore: Bool =  false
    var isTapImageAfter: Bool = false


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        procedures.append(procedure1)
        procedures.append(procedure2)
        procedures.append(procedure3)
        procedures.append(procedure4)
        procedures.append(procedure5)

        procedurePicker.delegate = self
        procedurePicker.dataSource = self
        
        clientInitialsLabel.text = client.makeInitials()
        beforeImageView.layer.cornerRadius = 64
        afterImageView.layer.cornerRadius = 64
        
        self.hideKeyboard()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        dateNow = dateFormatter.string(from: Date())
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "H:mm d MMM yyyy"
        dateForUser = dateFormatter2.string(from: Date())
        
        if let procedureCost = procedures[procedurePicker.selectedRow(inComponent: 0)].cost {
            costLabel.text = String(procedureCost)
        }
        
    }
    
    
    @IBAction func didPressMakeImageBefore(_ sender: UIButton) {
        isTapImageBefore = true
        showCameraOrLibrary()
    }
    
    @IBAction func didPressMakeImageAfter(_ sender: UIButton) {
        isTapImageAfter = true
        showCameraOrLibrary()
    }
    
    @IBAction func didPressEditCost(_ sender: UIButton) {
        //TODO: - NEED TO DO
        costLabel.text = editCostTextField.text
    }
    
    @IBAction func didPressAddProcedure(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        guard let imageBefore =  beforeImageView.image , let imageAfter = afterImageView.image else { return }
        
        let selectedProcedure = procedures[procedurePicker.selectedRow(inComponent: 0)]
        
        let nameProcedure = selectedProcedure.name ?? "noProcedure"
        //let costProcedure = selectedProcedure.cost ?? 0
        
        pickUnicalProcedureImageUrl(procedureName: nameProcedure, clientInitials: client.makeInitials(), image: imageBefore, imageBeforeOrAfter: "imageBeforeURL")
        pickUnicalProcedureImageUrl(procedureName: nameProcedure, clientInitials: client.makeInitials(), image: imageAfter, imageBeforeOrAfter: "imageAfterURL")
        
        let procedureConfiguration: [String: String] = [
            "nameProcedure": String(nameProcedure),
            "costProcedure": String(costLabel.text ?? "0"),
            "dateProcedure": String(dateNow),
            "dateProcedureForUser": String(dateForUser),
            "imageBeforeURL": "",
            "imageAfterURL": "",
            "initials": client.makeInitials(),
        ]

        
        //Mark: - add new procedure to selected client
        ref.child("\(uid ?? " ")/clients/\(client.makeInitials())/procedures/\(nameProcedure)_\(self.dateNow)").setValue(procedureConfiguration)
        
        //Mark: - add new procedure to branch where all is procedures
        info = "\(uid ?? " ")/procedures/\(dateNow)-\(nameProcedure)-\(client.makeInitials())"
        ref.child(info).setValue(procedureConfiguration)
    }
    
    
    func pickUnicalProcedureImageUrl(procedureName: String, clientInitials: String, image: UIImage, imageBeforeOrAfter: String){
        let uid = Auth.auth().currentUser?.uid
        
        
        let storageRef = Storage.storage().reference().child("\(uid ?? "errorPicture")_\(self.dateNow)_\(imageBeforeOrAfter)_\(clientInitials).jpg")
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        var result: String?
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            
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
                    ref.child("\(uid ?? " ")/clients/\(clientInitials)/procedures/\(procedureName)_\(self.dateNow)/\(imageBeforeOrAfter)").setValue(String(result ?? ""))
                    ref.child("\(uid ?? " ")/procedures/\(self.dateNow)-\(procedureName)-\(self.clientInitialsLabel.text ?? "error")/\(imageBeforeOrAfter)").setValue(String(result ?? ""))
                    //TODO: - maybe need to know when the image downloaded
                })
            })
        }
    }
    
    
    func showCameraOrLibrary() {
        let alert = UIAlertController(title: "Выберите", message: "Камера или Галерея", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (_) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showReadyNewProcedure" {
            if let destination = segue.destination as? ReadyViewController {
                destination.dataFromNewProcedure = info
            }
        }
    }
    
}


extension AddProcedureViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return procedures.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return procedures[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let procedureCost = procedures[row].cost else { return }
        costLabel.text = String(procedureCost)
    }
    
}

extension AddProcedureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            if  isTapImageBefore {
                beforeImageView.image = selectedImage
                isTapImageBefore = false
            } else {
                afterImageView.image = selectedImage
                isTapImageAfter = false
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

