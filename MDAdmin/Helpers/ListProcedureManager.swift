//
//  ListProcedureManager.swift
//  MDAdmin
//
//  Created by Denis on 7/18/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import Foundation
import Firebase

class ListProcedureManager {
    
    static let shared = ListProcedureManager()
    
    var listProcedures = [PossibleProcedure]()
    
    func getProcedure(completion: (([PossibleProcedure]) -> Void)?) {
        
        var tempPossibleProcedures = [PossibleProcedure]()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("\(uid ?? "")/listProcedures").observe(.value){ [weak self] (snapshot) in
            guard let dataFromDatabase = snapshot.value as? [String : [String: Any]] else {return}
            //print("DATA : \(dataFromDatabase)")
            
            dataFromDatabase.forEach { (key, value) in
                //print("key", key)
                //print("value", value)

                let possibleProcedure = PossibleProcedure(name: value["name"] as? String ?? " " ,
                                                          cost: Int(value["cost"] as? String ?? " "))
                tempPossibleProcedures.append(possibleProcedure)
                
            }
            guard let this = self else { return }
            this.listProcedures = tempPossibleProcedures
            tempPossibleProcedures = []
            completion?(this.listProcedures)
            
            
        }
    }
}
