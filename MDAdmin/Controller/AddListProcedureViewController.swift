//
//  AddListProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/18/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class AddListProcedureViewController: UIViewController {

    @IBOutlet weak var procedureCostTextField: UITextField!
    @IBOutlet weak var procedureNameTextField: UITextField!
    
    var procedureFromList = PossibleProcedure(name: "", cost: 0)
    var oldProcedure = PossibleProcedure(name: "", cost: 0)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        // Do any additional setup after loading the view.
        
        
        if let procedureName = procedureFromList.name, let procedureCost = procedureFromList.cost {
            if !procedureName.isEmpty {
                procedureNameTextField.text = procedureName
                procedureCostTextField.text = String(procedureCost)
                oldProcedure = PossibleProcedure(name: procedureName, cost: procedureCost)
            }
        }
        
        
    }
    
    @IBAction func didPressSaveProcedure(_ sender: UIButton) {
        guard let procedureName = procedureNameTextField.text, let procedureCost = procedureCostTextField.text else { return }
        
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        if !procedureName.isEmpty, !procedureCost.isEmpty{
            let possibleProcedure = PossibleProcedure(name: procedureName ,
                                                      cost: Int(procedureCost))
            
            let possibleProcedureConfiguration: [String: String] = [
                "name": possibleProcedure.name ?? " ",
                "cost": String(possibleProcedure.cost ?? 0)
            ]
            
            if let oldProcedureName = oldProcedure.name {
                if oldProcedureName != "" {
                    ref.child("\(uid ?? " ")/listProcedures/\(oldProcedureName)").setValue(nil)
                }
            }
            
            ref.child("\(uid ?? " ")/listProcedures/\(possibleProcedure.name ?? " ")").setValue(possibleProcedureConfiguration)
            
            
        }
        
        
    }
    

}
