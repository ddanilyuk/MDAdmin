//
//  ClientManager.swift
//  MDAdmin
//
//  Created by Denis on 7/9/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import Foundation
import Firebase

class ClientManager {
    
    static let shared = ClientManager()
    
    var clients = [Client]()
    
    func getClients(completion: (([Client]) -> Void)?) {
        
        var tempClients = [Client]()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        
        ref.child("\(uid ?? "")/clients").observe(.value){ [weak self] (snapshot) in
            guard let dataFromDatabase = snapshot.value as? [String : [String: Any]] else {return}
            //print("DATA : \(dataFromDatabase)")
            //tempClients = []

            dataFromDatabase.forEach { (key, value) in
                //print("key", key)
                
                if value["name"] as? String == "" { return }
                
                //print("value", value)
                let proceduresArray = value["procedures"] as? [String: [String: String]] ?? [:]
                var procedures: [Procedure] = []
                proceduresArray.forEach({ (key, value) in
                    let procedure = Procedure(initials: value["initials"] ?? "",
                                              nameProcedure: value["nameProcedure"] ?? "",
                                              dateProcedure: value["dateProcedure"] ?? "",
                                              costProcedure: value["costProcedure"] ?? "",
                                              imageBeforeURL: value["imageBeforeURL"] ?? "",
                                              imageAfterURL: value["imageAfterURL"] ?? "")
                    procedures.append(procedure)
                })
                
                
                let client = Client(name: value["name"] as? String ?? " ",
                                    surname: value["surname"] as? String ?? " ",
                                    patronymic: value["patronymic"] as? String ?? " ",
                                    imageURL: value["imageURL"] as? String ?? " ",
                                    procedures: procedures)
                tempClients.append(client)
                //print(client.procedures)
                
            }
            guard let this = self else { return }
            this.clients = tempClients
            completion?(this.clients)
            
        }
    }
}
