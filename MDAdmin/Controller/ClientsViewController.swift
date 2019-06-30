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
    
    private var clientList: [String : [String]] = [:]
    
    private var sectionHeader: [String] { return Array(clientList.keys).sorted(by: {$0 < $1}) }
    var initilsToSeque: String = " "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientTableView.delegate = self
        clientTableView.dataSource = self
        updateTable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateTable()
    }
    
    func updateTable() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("\(uid ?? " ")/clinets/").observe(.value) { (snapshot) in
            guard let data = snapshot.value as? [String: [String: String]] else {
                return
            }
            var header: [String] { return Array(data.keys).sorted(by: {$0 < $1}) }
            var userList: [String] = []
            for client in header {
                userList.append(client)
            }
            print(userList)
            
            
            for user in userList {
                let firstLetter = String(user[user.startIndex])
                
                var valuesForFirstLetter:[String] = self.clientList["\(firstLetter.uppercased())"] ?? [""]
                print("valuesForFirstLetter", valuesForFirstLetter)

                if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(user) {
                    valuesForFirstLetter = [String(user)]
                } else if !valuesForFirstLetter.contains(user){
                    valuesForFirstLetter.append(String(user))
                }
                
                self.clientList.updateValue(valuesForFirstLetter, forKey: firstLetter.uppercased())
                valuesForFirstLetter = []
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        initilsToSeque = clientList[sectionHeader[indexPath.section]]?[indexPath.row] ?? " "
        guard (storyboard?.instantiateViewController(withIdentifier: "OneClientViewController") as? OneClientViewController) != nil else { return }
        //present(newVC, animated: true, completion: nil)
        //navigationController?.pushViewController(newVC, animated: true)
        
        performSegue(withIdentifier: "showClient", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showClient" {
            if let destination = segue.destination as? OneClientViewController {       
                destination.initials = initilsToSeque
            }
        }
    }
}

