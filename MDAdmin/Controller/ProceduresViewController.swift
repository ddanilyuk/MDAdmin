//
//  ProceduresViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class ProceduresViewController: UIViewController {

    @IBOutlet weak var proceduresTableView: UITableView!
    
    let mainLocalProceduresList: [String: String] = [:]
    
    let reuseID = "someReuseID"
    var procedures = [Procedure]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceduresTableView.delegate = self
        proceduresTableView.dataSource = self
        getProceduresUpdateTable()
        
        refreshControl.addTarget(self, action: #selector(updateRefreshControll), for: .valueChanged)
        proceduresTableView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProceduresUpdateTable()
    }
    
    @objc func updateRefreshControll() {
        procedures = []
        getProceduresUpdateTable()
        refreshControl.endRefreshing()
    }
    
    func getProceduresUpdateTable() {
        ProcedureManager.shared.getClients { [weak self] procedures in
            guard let this = self else { return }
            
            this.procedures = []
            var datesProcedures: [String] = []
            this.procedures.forEach({ procedure in
                datesProcedures.append(procedure.dateProcedure)
            })
            
            for procedure in procedures {
                if !datesProcedures.contains(procedure.dateProcedure) {
                    this.procedures.append(procedure)
                }
            }
            this.procedures = this.procedures.sorted(by: {$0.dateProcedure > $1.dateProcedure})
            this.proceduresTableView.reloadData()
        }
    }
    

}

extension ProceduresViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return procedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        
        cell.textLabel?.text = procedures[indexPath.row].initials
        let detailText = "\(procedures[indexPath.row].nameProcedure) \(procedures[indexPath.row].dateProcedure)"
        cell.detailTextLabel?.text = detailText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (storyboard?.instantiateViewController(withIdentifier: "OneProcedureViewController") as? OneProcedureViewController) != nil else { return }
        performSegue(withIdentifier: "showProceduresDetailFromProcedures", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProceduresDetailFromProcedures" {
            if let indexPath = proceduresTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? OneProcedureViewController {
                    destination.procedure = procedures[indexPath.row]
                }
            }
        }
    }
    
}

