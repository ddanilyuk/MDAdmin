//
//  ReadyViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/7/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class ReadyViewController: UIViewController {
    
    @IBOutlet weak var imageLoadLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    var dataFromNewClient: String = ""
    var dataFromNewProcedure: String = ""
    @IBOutlet weak var readyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        readyLabel.text = "Не готово"
        imageLoadLabel.text = "Картинки не загружены, подождите"
        exitButton.isEnabled = false
        
        //Mark: - when segue from add client
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if dataFromNewClient != "" {
            ref.child(dataFromNewClient).observe(.childChanged) { snapshot in
                self.readyLabel.text = "Готово"
                self.imageLoadLabel.text = "Картинки загружены, клиент добавлен"
                self.exitButton.isEnabled = true
            }
        }
        
        //Mark: - when segue from add procedure
        var ref2: DatabaseReference!
        ref2 = Database.database().reference()

        if dataFromNewProcedure != "" {
            ref2.child(dataFromNewProcedure).observe(.childChanged) { snapshot in
                self.readyLabel.text = "Готово"
                self.imageLoadLabel.text = "Картинки загружены, процедура добавлена"
                self.exitButton.isEnabled = true
            }
        }
        
}
    
    @IBAction func didPressExit(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
