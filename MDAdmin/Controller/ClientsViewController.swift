//
//  ClientsViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class ClientsViewController: UIViewController{
    
    @IBOutlet weak var clientTableView: UITableView!
    
    private var clientList: [String : [String]] = [:
//        "A" :   ["Алещенко Анатолий Андреевич"],
//        "Б" :   ["Боровик Ростислав Сергеевич"],
//        "Д" :   ["Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна",
//                  "Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна",
//                  "Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна"],
//        "Г" :   ["Головаш Анастасія Васильівна"],
        //"К" :   ["Кухарук Юрій Григорович"]
    ]
    
    
    
    //var clients: [String: [Clients]]
    
    private var sectionHeader: [String] { return Array(clientList.keys).sorted(by: {$0 < $1}) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let ref = Database.database().reference()
        ref.child("123123").setValue(["fullName": "Денис"])
        ref.child("hello")
        */
        clientTableView.delegate = self
        clientTableView.dataSource = self
        
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        
        
        ref.child("\(uid ?? " ")/clinets/").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: [String: String]] else {
                return
            }
            var header: [String] { return Array(data.keys).sorted(by: {$0 < $1}) }
            var userList: [String] = []
            for client in header{
                userList.append(client)
            }
            print(userList)
            print(data)
            
            
            for user in userList {
                let firstLetter = String(user[user.startIndex])
                print("first letter of \(user) is \(firstLetter)")
    
                self.clientList.updateValue([user], forKey: firstLetter)
            }
            self.clientTableView.reloadData()
            
        }
        //ref.child("\(uid ?? " ")/clinets/").o
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        
        
        ref.child("\(uid ?? " ")/clinets/").observeSingleEvent(of: .value) { (snapshot) in
            guard let data = snapshot.value as? [String: [String: String]] else {
                return
            }
            var header: [String] { return Array(data.keys).sorted(by: {$0 < $1}) }
            var userList: [String] = []
            for client in header{
                userList.append(client)
            }
            print(userList)
            print(data)
            
            
            for user in userList {
                let firstLetter = String(user[user.startIndex])
                print("first letter of \(user) is \(firstLetter)")
                
                self.clientList.updateValue([user], forKey: firstLetter)
            }
            self.clientTableView.reloadData()
            
        
    }
}
}
extension ClientsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return clientList.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionHeader[section]
        return clientList[key]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = clientList[sectionHeader[indexPath.section]]?[indexPath.row]
        
        return cell
    }
}
