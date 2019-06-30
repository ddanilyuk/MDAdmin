//
//  OneClientViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/30/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class OneClientViewController: UIViewController {

    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientSurnameLabel: UILabel!
    @IBOutlet weak var clientPatrynomicLabel: UILabel!
    @IBOutlet weak var navBarNameClient: UINavigationItem!
    
    var initials: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //clientNameLabel.text = initials
        navBarNameClient.title = initials
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
