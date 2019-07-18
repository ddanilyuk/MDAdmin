//
//  EditProceduresViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/18/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class EditListProceduresViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let reuseID = "listProcedure"
    var possibleProcedures = [PossibleProcedure]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getProceduresUpdateTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProceduresUpdateTable()
    }
    
    @IBAction func didPressAddNewProcedures(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    func getProceduresUpdateTable() {
        possibleProcedures = []
        ListProcedureManager.shared.getProcedure( completion: { [weak self] possibleProcedures in
            guard let this = self else { return }
            
            this.possibleProcedures = possibleProcedures.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            this.tableView.reloadData()
            print(this.possibleProcedures)
        })
        self.tableView.reloadData()
    }

}

extension EditListProceduresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleProcedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        //print(possibleProcedures[indexPath.row].name ?? "123")
        cell.textLabel?.text = possibleProcedures[indexPath.row].name
        if let procedureCost = possibleProcedures[indexPath.row].cost {
            cell.detailTextLabel?.text = String(procedureCost)
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (storyboard?.instantiateViewController(withIdentifier: "AddListProcedureViewController") as? AddListProcedureViewController) != nil else { return }
        performSegue(withIdentifier: "showProcedureDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProcedureDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? AddListProcedureViewController {
                    destination.procedureFromList = possibleProcedures[indexPath.row]
                }
            }
        }
    }
    
    
}
