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
        //getProceduresUpdateTable()
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("\(uid ?? "")/procedures").observe(.childChanged) { procedure in
            self.proceduresTableView.reloadData()
        }
    }
    
    @objc func updateRefreshControll() {
        procedures = []
        getProceduresUpdateTable()
        refreshControl.endRefreshing()
    }
    
    func getProceduresUpdateTable() {
        procedures = []
        ProcedureManager.shared.getProcedure( completion: { [weak self] procedures in
            guard let this = self else { return }
            
            var datesProcedures: [String] = []
//            this.procedures.forEach({ procedure in
//                datesProcedures.append(procedure.dateProcedure)
//            })
            
//            var newProcedures: [Procedure] = []
//            for procedure in procedures {
//                this.procedures.forEach({ procedure in
//                    datesProcedures.append(procedure.dateProcedure)
//                })
//                if !datesProcedures.contains(procedure.dateProcedure) {
//                    newProcedures.append(procedure)
//                }
//                datesProcedures = []
//            }
            
            self?.procedures = procedures.sorted(by: {$0.dateProcedure > $1.dateProcedure})
            self?.proceduresTableView.reloadData()
        })
        self.proceduresTableView.reloadData()
    }
    

}

extension ProceduresViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return procedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        
        cell.textLabel?.text = procedures[indexPath.row].initials
        let detailText = "\(procedures[indexPath.row].nameProcedure) \(procedures[indexPath.row].dateProcedureForUser)"
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

