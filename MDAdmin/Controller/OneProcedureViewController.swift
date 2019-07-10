//
//  OneProcedureViewController.swift
//  MDAdmin
//
//  Created by Denis on 7/7/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class OneProcedureViewController: UIViewController {
    @IBOutlet weak var clientName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var beforeImageView: UIImageView!
    @IBOutlet weak var afterImageView: UIImageView!
    @IBOutlet weak var titleNavItem: UINavigationItem!
    
    
    
    var procedure: Procedure = Procedure(initials: "", nameProcedure: "", dateProcedure: "", dateProcedureForUser: "", costProcedure: "", imageBeforeURL: "", imageAfterURL: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clientName.text = procedure.initials
        titleNavItem.title = procedure.nameProcedure
        dateLabel.text = procedure.dateProcedureForUser
        costLabel.text = "\(procedure.costProcedure) грн"
        
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
    
    @IBAction func didPressDeleteProcedure(_ sender: UIButton) {
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        var ref2: DatabaseReference!
        ref2 = Database.database().reference()
        let alert = UIAlertController(title: "Удалить?", message: "Вы действительно хотите удалить процедуру?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { (_) in
            print(self.procedure.nameProcedure)
            print("\(uid ?? " ")/clients/\(self.procedure.initials)/procedures/\(self.procedure.nameProcedure)_\(self.procedure.dateProcedure)")
            ref.child("\(uid ?? " ")/clients/\(self.procedure.initials)/procedures/\(self.procedure.nameProcedure)_\(self.procedure.dateProcedure)").setValue(nil)
            ref2.child("\(uid ?? " ")/procedures/\(self.procedure.dateProcedure)-\(self.procedure.nameProcedure)-\(self.procedure.initials)").setValue(nil)

            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: {
        })
        //        ref.child("\(uid ?? " ")/clients/\(client.makeInitials())").setValue(nil)
        //        navigationController?.popViewController(animated: true)

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
