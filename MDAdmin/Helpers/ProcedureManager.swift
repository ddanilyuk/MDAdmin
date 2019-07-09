//
//  ProcedureManager.swift
//  MDAdmin
//
//  Created by Denis on 7/9/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import Foundation
import Firebase

class ProcedureManager {
    
    static let shared = ProcedureManager()
    
    var procedures = [Procedure]()
    
    func getClients(completion: (([Procedure]) -> Void)?) {
        
        var tempProcedures = [Procedure]()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("\(uid ?? "")/procedures").observe(.value){ [weak self] (snapshot) in
            guard let dataFromDatabase = snapshot.value as? [String : [String: String]] else {return}
            //print("DATA : \(dataFromDatabase)")
            
            dataFromDatabase.forEach { (key, value) in
                //print("key", key)
                //print("value", value)

                let procedure = Procedure(initials: value["initials"] ?? " ",
                                          nameProcedure: value["nameProcedure"] ?? " ",
                                          dateProcedure: value["dateProcedure"] ?? " ",
                                          costProcedure: value["costProcedure"] ?? " ",
                                          imageBeforeURL: value["imageBeforeURL"] ?? " ",
                                          imageAfterURL: value["imageAfterURL"] ?? " ")
                tempProcedures.append(procedure)
                
            }
            guard let this = self else { return }
            this.procedures = tempProcedures
            completion?(this.procedures)
            
        }
    }
}
