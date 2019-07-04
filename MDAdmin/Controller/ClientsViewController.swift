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
    
    private var mainLocalClientList: [String : [String]] = [:]
    var temp: [String : [String]] = [:]
    

    private var searchLocalClientList: [String : [String]] = [:]

    private var sectionHeader: [String] { return Array(mainLocalClientList.keys).sorted(by: {$0 < $1}) }
    
    var initialsToSeque: String = " "
    var dataToSeque: [String : [String:String]] = [:]
    var refreshControl = UIRefreshControl()
    var search = UISearchController()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientTableView.delegate = self
        clientTableView.dataSource = self
        updateTable()
        temp = mainLocalClientList

        
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        refreshControl.addTarget(self, action: #selector(updateRefreshControll), for: .valueChanged)
        clientTableView.refreshControl = refreshControl
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //test with Firebase
        //updateTable()
        //temp = mainLocalClientList
    }
    
    
    func updateTable() {
        let uid = Auth.auth().currentUser?.uid

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("\(uid ?? " ")/clinets/").observe(.value) { (snapshot) in
            self.dataToSeque = snapshot.value as? [String: [String: String]] ?? [:]
            
            var keysInitialsFromServer: [String] { return Array(self.dataToSeque.keys).sorted(by: {$0 < $1}) }
            var userList: [String] = []
            
            for client in keysInitialsFromServer {
                //making list of user initils for key in server
                userList.append(client)
            }

            for user in userList {
                
                let firstLetter = String(user[user.startIndex])
                
                //recieving old values for first letter from second name
                var valuesForFirstLetter:[String] = self.mainLocalClientList["\(firstLetter.uppercased())"] ?? [""]

                if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(user) {
                    valuesForFirstLetter = [String(user)]
                } else if !valuesForFirstLetter.contains(user){
                    valuesForFirstLetter.append(String(user))
                }
                
                //updating mainLocalClientList
                self.mainLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.uppercased())
                valuesForFirstLetter = []
            }
            self.temp = self.mainLocalClientList
            self.clientTableView.reloadData()
        }
        
    }
    
    @objc func updateRefreshControll(){
        //update full tableView from server with deleting local information
        //used in UIRefreshControl
        let uid = Auth.auth().currentUser?.uid

        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        mainLocalClientList = [:]

        ref.child("\(uid ?? " ")/clinets/").observe(.value) { (snapshot) in
            self.dataToSeque = snapshot.value as? [String: [String: String]] ?? [:]
            
            var keysInitialsFromServer: [String] { return Array(self.dataToSeque.keys).sorted(by: {$0 < $1}) }
            var userList: [String] = []
            
            for client in keysInitialsFromServer {
                //making list of user initils for key in server
                userList.append(client)
            }
            
            for user in userList {
                
                let firstLetter = String(user[user.startIndex])
                
                //recieving old values for first letter from second name
                var valuesForFirstLetter:[String] = self.mainLocalClientList["\(firstLetter.uppercased())"] ?? [""]
                
                if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(user) {
                    valuesForFirstLetter = [String(user)]
                } else if !valuesForFirstLetter.contains(user){
                    valuesForFirstLetter.append(String(user))
                }
                
                //updating mainLocalClientList
                self.mainLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.uppercased())
                valuesForFirstLetter = []
            }
            self.temp = self.mainLocalClientList
            self.clientTableView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    
}


extension ClientsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainLocalClientList.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionHeader[section]
        return mainLocalClientList[key]?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = mainLocalClientList[sectionHeader[indexPath.section]]?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pushing information about selected client to OneClientViewController
        initialsToSeque = mainLocalClientList[sectionHeader[indexPath.section]]?[indexPath.row] ?? " "
        guard (storyboard?.instantiateViewController(withIdentifier: "OneClientViewController") as? OneClientViewController) != nil else { return }
        performSegue(withIdentifier: "showClient", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showClient" {
            if let destination = segue.destination as? OneClientViewController {       
                destination.initials = initialsToSeque
                destination.fullData = dataToSeque
            }
        }
    }
    
}


extension ClientsViewController: UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? " ")
        //mainLocalClientList = searchLocalClientList
        guard let searchText = searchController.searchBar.text else {
            return
        }
        //searchLocalClientList = mainLocalClientList

        guard !searchText.isEmpty else {
            mainLocalClientList = temp
            return
        }
        print("searchLocalClientList -> ", searchLocalClientList)
        print("mainLocalClientList -> ", mainLocalClientList)
        searchLocalClientList = mainLocalClientList
        var headers: [String] { return Array(mainLocalClientList.keys).sorted(by: {$0 < $1}) }
        mainLocalClientList = [:]
        print("mainLocalClientList.keys -> ", mainLocalClientList.keys)
        print("headers -> ", headers)
        for firstLetter in searchLocalClientList {
            print(firstLetter)
            for value in searchLocalClientList["\(firstLetter.key.uppercased())"] ?? [""] {
                if value.contains(searchText) {
                    var valuesForFirstLetter:[String] = self.searchLocalClientList["\(firstLetter.key.uppercased())"] ?? [""]
                    if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(value) {
                        valuesForFirstLetter = [String(value)]
                    } else if !valuesForFirstLetter.contains(value){
                        valuesForFirstLetter.append(String(value))
                    }
                    mainLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.key)
                    valuesForFirstLetter = []
                    print(mainLocalClientList)
                }
            }
        }
        print("searchLocalClientList -> ", searchLocalClientList)
        print("mainLocalClientList -> ", mainLocalClientList)
        clientTableView.reloadData()

        
    }
    
        
        
//        var userList: [String] = []
//
//        for client in sectionHeader {
//            //making list of user initils for key in server
//            userList.append(client)
//        }
//
//        for user in userList {
//            let firstLetter = String(user[user.startIndex])
//
//            if user.contains(String(searchController.searchBar.text ?? " ")) {
//
//            }
//
//
//            //recieving old values for first letter from second name
//            var valuesForFirstLetter:[String] = self.searchLocalClientList["\(firstLetter.uppercased())"] ?? [""]
//
//            if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(user) {
//                valuesForFirstLetter = [String(user)]
//            } else if !valuesForFirstLetter.contains(user){
//                valuesForFirstLetter.append(String(user))
//            }
//
//            //updating mainLocalClientList
//            self.searchLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.uppercased())
//            valuesForFirstLetter = []
//            print(searchLocalClientList)
//        }
    

}
