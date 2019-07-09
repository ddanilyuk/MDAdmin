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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var titleNavItem: UINavigationItem!
    
    
    var procedure: Procedure = Procedure(initials: "", nameProcedure: "", dateProcedure: "", costProcedure: "", imageBeforeURL: "", imageAfterURL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientName.text = procedure.initials
        titleNavItem.title = procedure.nameProcedure
        dateLabel.text = procedure.dateProcedure
        costLabel.text = procedure.costProcedure
        
        beforeImageView.layer.cornerRadius = 64
        afterImageView.layer.cornerRadius = 64
        
        //Mark: - old downloading images with caching
        //beforeImageView.loadImageUsingCacheWithUrlString(procedure.imageBeforeURL)
        //afterImageView.loadImageUsingCacheWithUrlString(procedure.imageAfterURL)
        
        beforeImageView.image = ImageStorage.getBeforeProcedureImage(procedure: procedure, imageView: beforeImageView)
        afterImageView.image = ImageStorage.getAfterProcedureImage(procedure: procedure, imageView: afterImageView)

    }

    @IBAction func didPressShowBigPictureBefore(_ sender: UIButton) {
        
    }
    
    @IBAction func didPressShowBigPictureAfter(_ sender: UIButton) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showBigPictureBefore" {
            if let destination = segue.destination as? BigPictureViewController {
                destination.myImage = beforeImageView.image ?? UIImage()
            }
        }
        
        if segue.identifier == "showBigPictureAfter" {
            if let destination = segue.destination as? BigPictureViewController {
                destination.myImage = afterImageView.image ?? UIImage()
            }
        }
    }
    
}
