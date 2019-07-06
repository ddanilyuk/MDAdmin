//
//  OneProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/7/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class OneProcedureViewController: UIViewController {
    @IBOutlet weak var clientName: UILabel!
    
    @IBOutlet weak var titleNavItem: UINavigationItem!
    var procedure: Procedure = Procedure(initials: "", nameProcedure: "", dateProcedure: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientName.text = procedure.initials
        titleNavItem.title = procedure.nameProcedure
        
    }
    


}
