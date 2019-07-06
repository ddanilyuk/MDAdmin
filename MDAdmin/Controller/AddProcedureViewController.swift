//
//  AddProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class AddProcedureViewController: UIViewController {
    
    
    @IBOutlet weak var editCostTextField: UITextField!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var clientInitialsLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var procedurePicker: UIPickerView!
    
    let procedure1 = Procedure(name: "procedure1", cost: 100)
    let procedure2 = Procedure(name: "procedure2", cost: 200)
    let procedure3 = Procedure(name: "procedure3", cost: 300)
    let procedure4 = Procedure(name: "procedure4", cost: 400)
    let procedure5 = Procedure(name: "procedure5", cost: 500)

    var procedures = [Procedure]()
    var clientInitialsFromFindClient = ""
    let imagePicker = UIImagePickerController()
    var imageBefore: UIImage?
    var imageAfter: UIImage?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        procedures.append(procedure1)
        procedures.append(procedure2)
        procedures.append(procedure3)
        procedures.append(procedure4)
        procedures.append(procedure5)

        procedurePicker.delegate = self
        procedurePicker.dataSource = self
        
        clientInitialsLabel.text = clientInitialsFromFindClient
        beforeImageView.layer.cornerRadius = 64
        afterImageView.layer.cornerRadius = 64
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func didPressMakeImageBefore(_ sender: UIButton) {
        showCameraOrLibrary()
    }
    
    @IBAction func didPressMakeImageAfter(_ sender: UIButton) {
        showCameraOrLibrary()
        
    }
    
    @IBAction func didPressEditCost(_ sender: UIButton) {
        
    }
    
    func showCameraOrLibrary() {
        let alert = UIAlertController(title: "Выберите", message: "Камера или Галерея", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (_) in
            print("User click camera button")
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (_) in
            print("User click library button")
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = true
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
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
            if imageBefore == nil {
                imageBefore = selectedImage
                beforeImageView.image = imageBefore

            } else {
                imageAfter = selectedImage
                afterImageView.image = imageAfter
            }
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

