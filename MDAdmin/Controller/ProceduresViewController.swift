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
    var listProcedures = [Procedure]()
    var refreshControl = UIRefreshControl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceduresTableView.delegate = self
        proceduresTableView.dataSource = self
        updateTable()
        
        refreshControl.addTarget(self, action: #selector(updateRefreshControll), for: .valueChanged)
        proceduresTableView.refreshControl = refreshControl
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func updateTable() {
        let uid = Auth.auth().currentUser?.uid
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        //ref.child("\(uid ?? " ")/clinets/\(clientInitialsLabel.text ?? "error")/procedures/\(procedureName)_\(self.dateNow)/").setValue()
        
        ref.child("\(uid ?? " ")/procedures/").observe(.value) { (snapshot) in
            //print(snapshot)
            guard let infoFromServer = snapshot.value as? [String: Any] else { return }
            

            for proc in infoFromServer {
                guard let values = proc.value as? [String: String] else { return }
                let procedure = Procedure(initials: values["client"] ?? "", nameProcedure: values["procedureName"] ?? "", dateProcedure: values["date"] ?? "", costProcedure: values["cost"] ?? "", imageBeforeURL: values["imageBefore"] ?? "", imageAfterURL: values["imageAfter"] ?? "")
                //print(procedure)
                /*
                 //Mark: - иногда появлеться несколько одинаковых процедур (нужно пофиксить)
                for procedureFromLastList in self.listProcedures{
                    print(procedureFromLastList.dateProcedure)
                    print(procedure.dateProcedure)
                    if !procedureFromLastList.dateProcedure.contains(procedure.dateProcedure){
                        
                    }
                }
                */
                self.listProcedures.append(procedure)
            }
            
            self.listProcedures = self.listProcedures.sorted(by: {$0.dateProcedure > $1.dateProcedure})
            self.proceduresTableView.reloadData()

        }

        
        
    }
    
    @objc func updateRefreshControll() {
        listProcedures = []
        updateTable()
        refreshControl.endRefreshing()
    }
    

}

extension ProceduresViewController:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProcedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        
        cell.textLabel?.text = listProcedures[indexPath.row].initials
        let detailText = "\(listProcedures[indexPath.row].nameProcedure) \(listProcedures[indexPath.row].dateProcedure)"
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
                    destination.procedure = listProcedures[indexPath.row]
                }
            }
        }
    }
    
}

