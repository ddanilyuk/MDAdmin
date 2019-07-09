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
    
    var isSearching = false
    var refreshControl = UIRefreshControl()
    let search = UISearchController(searchResultsController: nil)
    let reuseID = "reuseID"
    
    //here will be try to use class Client in clientsViewController
    var clients: [Client] = []
    var newMainLocalClientList: [String: [Client]] = [:]
    var newSearchLocalClientList: [String: [Client]] = [:]

    private var newSectionHeader: [String] { return Array(newMainLocalClientList.keys).sorted(by: {$0 < $1}) }
    private var newSectionSearchHeader: [String] { return Array(newSearchLocalClientList.keys).sorted(by: {$0 < $1}) }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        getClientsUpadateTable()
        
        clientTableView.delegate = self
        clientTableView.dataSource = self
        
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Поиск клиентов"
        self.navigationItem.searchController = search
        definesPresentationContext = true
        //navigationItem.hidesSearchBarWhenScrolling = false

        refreshControl.addTarget(self, action: #selector(updateRefreshControll), for: .valueChanged)
        clientTableView.refreshControl = refreshControl
        
    }
    
    
    @objc func updateRefreshControll(){
        //Mark: - update full tableView from server with deleting local information
        //Mark: - used in UIRefreshControl
        newMainLocalClientList = [:]
        getClientsUpadateTable()
        refreshControl.endRefreshing()

    }
    
    func getClientsUpadateTable() {
        ClientManager.shared.getClients { [weak self] clients in
            guard let this = self else { return }
            this.clients = clients
            for client in this.clients {
                
                let firstLetter = client.getFirstLetter()
                
                //Mark: - recieving old values for first letter from second name
                var valuesForFirstLetter:[Client] = self?.newMainLocalClientList["\(firstLetter.uppercased())"] ?? []
                var valuesForFirstLetterInitials = ""
                
                //Mark: - recieving initials to check if not contains
                valuesForFirstLetter.forEach({ (client) in
                    valuesForFirstLetterInitials = client.makeInitials()
                })
                
                if valuesForFirstLetter.isEmpty, !valuesForFirstLetterInitials.contains(client.makeInitials()) {
                    valuesForFirstLetter = [client]
                } else if !valuesForFirstLetterInitials.contains(client.makeInitials()){
                    valuesForFirstLetter.append(client)
                }
                
                //Mark: - updating main tableView
                self?.newMainLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.uppercased())
                valuesForFirstLetter = []
            }
            self?.clientTableView.reloadData()
        }
    }
}

//Mark: - extensions for tables
extension ClientsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching {
            return newSearchLocalClientList.keys.count
        } else {
            return newMainLocalClientList.keys.count

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isSearching {
            return newSectionSearchHeader[section]
        } else {
            return newSectionHeader[section]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            let key = newSectionSearchHeader[section]
            return newSearchLocalClientList[key]?.count ?? 0
        } else {
            let key = newSectionHeader[section]
            return newMainLocalClientList[key]?.count ?? 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
        
        if isSearching {
            cell.textLabel?.text = newSearchLocalClientList[newSectionSearchHeader[indexPath.section]]?[indexPath.row].makeInitials()
        } else {
            cell.textLabel?.text = newMainLocalClientList[newSectionHeader[indexPath.section]]?[indexPath.row].makeInitials()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Mark: - pushing information about selected client to OneClientViewController
        guard (storyboard?.instantiateViewController(withIdentifier: "OneClientViewController") as? OneClientViewController) != nil else { return }
        performSegue(withIdentifier: "showClient", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showClient" {
            if let indexPath = clientTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? OneClientViewController {
                    if isSearching {
                        destination.client = newSearchLocalClientList[newSectionSearchHeader[indexPath.section]]?[indexPath.row] ?? Client()
                        
                    } else {
                        destination.client = newMainLocalClientList[newSectionHeader[indexPath.section]]?[indexPath.row] ?? Client()
                    }
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
            newSearchLocalClientList = [:]
            clientTableView.reloadData()
        } else {
            isSearching = true
            newSearchLocalClientList = [:]
            
            for firstLetter in newMainLocalClientList {
                
                for value in newMainLocalClientList["\(firstLetter.key.uppercased())"] ?? [] {
                    if value.makeInitials().lowercased().contains(searchText.lowercased()) {
                        var valuesForFirstLetter:[Client] = self.newSearchLocalClientList["\(firstLetter.key.uppercased())"] ?? []
                        
                        var valuesForFirstLetterInitials = ""
                        
                        //Mark: - recieving initials to check if not contains
                        valuesForFirstLetter.forEach({ (client) in
                            valuesForFirstLetterInitials = client.makeInitials()
                        })
                        
                        if valuesForFirstLetter.isEmpty, !valuesForFirstLetterInitials.contains(value.makeInitials()) {
                            valuesForFirstLetter = [value]
                        } else if !valuesForFirstLetterInitials.contains(value.makeInitials()){
                            valuesForFirstLetter.append(value)
                        }
                        newSearchLocalClientList.updateValue(valuesForFirstLetter, forKey: firstLetter.key)
                        valuesForFirstLetter = []
                    }
                }
            }
            clientTableView.reloadData()
        }
    }
    
}
