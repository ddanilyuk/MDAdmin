//
//  BigPictureViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/4/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class BigPictureViewController: UIViewController {

    var myImage: UIImage = UIImage()
    
    @IBOutlet weak var bigImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bigImageView.image = myImage
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
