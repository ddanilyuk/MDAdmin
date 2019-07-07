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
    var dataFromNewClient: String = ""
    var dataFromNewProcedure: String = ""
    @IBOutlet weak var readyLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        readyLabel.text = "Не готово"
        print(dataFromNewClient)
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child(dataFromNewClient).observe(.childChanged) { snapshot in
            self.readyLabel.text = "Готово"
            print(snapshot)
        }
        // Do any additional setup after loading the view.
    }
    

}
