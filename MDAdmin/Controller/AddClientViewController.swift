//
//  AddViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class AddClientViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var clientPhoto: UIImageView!
    
    @IBAction func didPressSetPhoto(_ sender: UIButton) {
        showSimpleActionSheet()        
    }
    
    func showSimpleActionSheet() {
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            print("User click Approve button")
            self.imagePicker.sourceType = .camera
            

        }))
        
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { (_) in
            print("User click Edit button")
            self.imagePicker.sourceType = .photoLibrary
            

        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
            self.imagePicker.delegate = self
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        )
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
