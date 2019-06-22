//
//  ClientsViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class ClientsViewController: UIViewController{
    
    @IBOutlet weak var clientTableView: UITableView!
    
    private let clientList: [String : [String]] = [
        "A" :   ["Алещенко Анатолий Андреевич"],
        "Б" :   ["Боровик Ростислав Сергеевич"],
        "Д" :   ["Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна",
                  "Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна",
                  "Данилюк Денис Андреевич", "Данилюк Оксана Юрьевна"],
        "Г" :   ["Головаш Анастасія Васильівна"],
        "К" :   ["Кухарук Юрій Григорович"]
    ]
    
    private var sectionHeader: [String] { return Array(clientList.keys).sorted(by: {$0 < $1}) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clientTableView.delegate = self
        clientTableView.dataSource = self
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
