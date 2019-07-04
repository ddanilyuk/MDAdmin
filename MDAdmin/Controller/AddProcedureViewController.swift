//
//  AddProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class AddProcedureViewController: UIViewController {
    let procedure1 = Procedure(name: "procedure1", cost: 100)
    let procedure2 = Procedure(name: "procedure2", cost: 200)
    let procedure3 = Procedure(name: "procedure3", cost: 300)
    let procedure4 = Procedure(name: "procedure4", cost: 400)
    let procedure5 = Procedure(name: "procedure5", cost: 500)


    var procedures = [Procedure]()

    @IBOutlet weak var procedurePicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        procedures.append(procedure1)
        procedures.append(procedure2)
        procedures.append(procedure3)
        procedures.append(procedure4)
        procedures.append(procedure5)

        procedurePicker.delegate = self
        procedurePicker.dataSource = self
        
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
    
}
