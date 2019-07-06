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
    private var searchLocalClientList: [String : [String]] = [:]
    
    var isSearching = false

    private var sectionHeader: [String] { return Array(mainLocalClientList.keys).sorted(by: {$0 < $1}) }
    private var sectionSearchHeader: [String] { return Array(searchLocalClientList.keys).sorted(by: {$0 < $1}) }

    
    var dataToSeque: [String : [String:String]] = [:]
    var refreshControl = UIRefreshControl()
    let search = UISearchController(searchResultsController: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientTableView.delegate = self
        clientTableView.dataSource = self
        updateTable()

        
        
        
        search.searchResultsUpdater = self
        //search.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск клиентов"
        self.navigationItem.searchController = search
        definesPresentationContext = true
        //self.navigationItem.sear
        
        
        refreshControl.addTarget(self, action: #selector(updateRefreshControll), for: .valueChanged)
        clientTableView.refreshControl = refreshControl
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //Mark: - test with Firebase
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
            self.clientTableView.reloadData()
        }
        
    }
    
    @objc func updateRefreshControll(){
        //update full tableView from server with deleting local information
        //used in UIRefreshControl
        mainLocalClientList = [:]
        updateTable()
        refreshControl.endRefreshing()
    }
    
    
}

//Mark: - extensions for tables
extension ClientsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return searchLocalClientList.keys.count
        } else {
            return mainLocalClientList.keys.count

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isSearching {
            return sectionSearchHeader[section]
        } else {
            return sectionHeader[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var key = sectionHeader[section]

        if isSearching {
            key = sectionSearchHeader[section]
        }

        if isSearching {
            return searchLocalClientList[key]?.count ?? 0
        } else {
            return mainLocalClientList[key]?.count ?? 0
        }

    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if isSearching {
            cell.textLabel?.text = searchLocalClientList[sectionSearchHeader[indexPath.section]]?[indexPath.row]
        } else {
            cell.textLabel?.text = mainLocalClientList[sectionHeader[indexPath.section]]?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //pushing information about selected client to OneClientViewController
        guard (storyboard?.instantiateViewController(withIdentifier: "OneClientViewController") as? OneClientViewController) != nil else { return }
        performSegue(withIdentifier: "showClient", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showClient" {
            if let indexPath = clientTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? OneClientViewController {
                    if isSearching {
                        destination.initials = searchLocalClientList[sectionSearchHeader[indexPath.section]]?[indexPath.row] ?? " "
                    } else {
                         destination.initials = mainLocalClientList[sectionHeader[indexPath.section]]?[indexPath.row] ?? " "
                    }
                    destination.fullData = dataToSeque
                }
            }
        }
        
        
    }
    
}

//Mark: - extencions for search
extension ClientsViewController: UISearchResultsUpdating{

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        if searchText == "" {
            isSearching = false
            searchLocalClientList = [:]
            clientTableView.reloadData()
        } else {
            isSearching = true
            searchLocalClientList = [:]

            for firstLetter in mainLocalClientList {

                for value in mainLocalClientList["\(firstLetter.key.uppercased())"] ?? [""] {
                    if value.lowercased().contains(searchText.lowercased()) {
                        var valuesForFirstLetter:[String] = self.searchLocalClientList["\(firstLetter.key.uppercased())"] ?? [""]
                        if valuesForFirstLetter == [""], !valuesForFirstLetter.contains(value) {
                            valuesForFirstLetter = [String(value)]
                        } else if !valuesForFirstLetter.contains(value){
                            valuesForFirstLetter.append(String(value))
                        }
                        searchLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.key)
                        valuesForFirstLetter = []
                    }
                }
            }
            //print(searchLocalClientList)
            clientTableView.reloadData()
        }
        
    }
}
