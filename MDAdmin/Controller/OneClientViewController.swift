//
//  OneClientViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/30/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

//struct Client: Codable {
//    let imageUrl: String
//}

class OneClientViewController: UIViewController {

    @IBOutlet weak var clientImage: UIImageView!

    @IBOutlet weak var navBarNameClient: UINavigationItem!
    @IBOutlet weak var proceduresTableView: UITableView!
    
    
    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var clientSurnameTextField: UITextField!
    @IBOutlet weak var clientPatrynomicTextField: UITextField!
    @IBOutlet weak var clientEmailTextField: UITextField!
    @IBOutlet weak var clientBirthdayTextField: UITextField!
    
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    
    var newProceduresArray: [Procedure] = []
    
    var client: Client = Client()
    
    var reuseID = "newReuseID"
    var listProcedures = [Procedure]()
    
    @IBAction func didPressBigPicture(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        
        clientImage.layer.cornerRadius = 75
        navBarNameClient.title = client.makeInitials()

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"

        
        clientNameTextField.text = client.name
        clientSurnameTextField.text = client.surname
        clientPatrynomicTextField.text = client.patronymic
        clientEmailTextField.text = client.email
        clientBirthdayTextField.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(client.birthday)))

        
        
        listProcedures = client.procedures
        self.listProcedures = self.listProcedures.sorted(by: {$0.dateProcedure > $1.dateProcedure})
        self.proceduresTableView.reloadData()
        proceduresTableView.delegate = self
        proceduresTableView.dataSource = self
        
        
        clientImage.image = ImageStorage.getClientImage(client: client, imageView: clientImage)
        
        
        //Mark: - another way to download image
        //guard let url = URL(string: imageURLClient) else { return }
        //downloadImage(from: url)
        
        //Mark: - another way to download image with caching
        //clientImage.loadImageUsingCacheWithUrlString(client.imageURL)
    }
    
    @IBAction func didPressEdit(_ sender: UIBarButtonItem) {
        isEditing = isEditing == true ? false : true
        if isEditing {
            clientNameTextField.isEnabled = true
            clientNameTextField.borderStyle = .roundedRect
            clientSurnameTextField.isEnabled = true
            clientSurnameTextField.borderStyle = .roundedRect
            clientPatrynomicTextField.isEnabled = true
            clientPatrynomicTextField.borderStyle = .roundedRect
            clientEmailTextField.isEnabled = true
            clientEmailTextField.borderStyle = .roundedRect
            
            
            //TODO: - add  edit
            editBarButton.title = "Готово"
            
            
            
            
        } else {
            let uid = Auth.auth().currentUser?.uid
            var ref1: DatabaseReference!
            ref1 = Database.database().reference()
            
            var ref2: DatabaseReference!
            ref2 = Database.database().reference()
            
            var ref3: DatabaseReference!
            ref3 = Database.database().reference()
            
            var ref4: DatabaseReference!
            ref4 = Database.database().reference()
            
            var ref5: DatabaseReference!
            ref5 = Database.database().reference()
            
            
            
            let alert = UIAlertController(title: "Сохранить?", message: "Вы действительно сохранить?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { (_) in
                
                
                let newClientName = self.clientNameTextField.text ?? " "
                let newClientSurname = self.clientSurnameTextField.text ?? " "
                let newClientPatrynomic = self.clientPatrynomicTextField.text ?? " "
                
                
                
                let newClient = Client(name: newClientName,
                                       surname: newClientSurname,
                                       patronymic: newClientPatrynomic,
                                       email: self.client.email,
                                       birthday: self.client.birthday,
                                       imageURL: self.client.imageURL,
                                       procedures: self.client.procedures)
                
                self.navBarNameClient.title = newClient.makeInitials()
                
                
                let clientConfiguration: [String: Any] = [
                    "surname": String(newClient.surname),
                    "name": String(newClient.name),
                    "patronymic": String(newClient.patronymic),
                    "email": String(newClient.email),
                    "birthday": Int(newClient.birthday),
                    "imageURL": String(newClient.imageURL),
                    "procedures": ""
                ]
                
                ref1.child("\(uid ?? " ")/clients/\(newClient.makeInitials())").setValue(clientConfiguration)
                
                ref4.child("\(uid ?? " ")/clients/\(self.client.makeInitials())").setValue(nil)
                
                for procedure in self.client.procedures {
                    let procedureConfiguration: [String: String] = [
                        "nameProcedure": String(procedure.nameProcedure),
                        "costProcedure": String(procedure.costProcedure),
                        "dateProcedure": String(procedure.dateProcedure),
                        "dateProcedureForUser": String(procedure.dateProcedureForUser),
                        "imageBeforeURL": String(procedure.imageBeforeURL),
                        "imageAfterURL": String(procedure.imageAfterURL),
                        "initials": newClient.makeInitials(),
                    ]
                    
                    //Mark: - add new procedure to selected client
                    ref2.child("\(uid ?? " ")/clients/\(newClient.makeInitials())/procedures/\(procedure.nameProcedure)_\(procedure.dateProcedure)").setValue(procedureConfiguration)
                    
                    
                    ref3.child("\(uid ?? " ")/procedures/\(procedure.dateProcedure)-\(procedure.nameProcedure)-\(newClient.makeInitials())").setValue(procedureConfiguration)
                    
                    ref5.child("\(uid ?? " ")/procedures/\(procedure.dateProcedure)-\(procedure.nameProcedure)-\(self.client.makeInitials())").setValue(nil)
                    
                }
                
                self.clientNameTextField.text = newClient.name
                self.clientSurnameTextField.text = newClient.surname
                self.clientPatrynomicTextField.text = newClient.patronymic
                self.clientEmailTextField.text = newClient.email
                
                self.navBarNameClient.title = newClient.makeInitials()
                
                
                
                //TODO: - maybe push up this part of code
                self.clientNameTextField.isEnabled = false
                self.clientNameTextField.borderStyle = .none
                self.clientSurnameTextField.isEnabled = false
                self.clientSurnameTextField.borderStyle = .none
                self.clientPatrynomicTextField.isEnabled = false
                self.clientPatrynomicTextField.borderStyle = .none
                self.clientEmailTextField.isEnabled = false
                self.clientEmailTextField.borderStyle = .none
                
                
                self.editBarButton.title = "Править"
                
            }))
            
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
                //TODO: - maybe push up this part of code
                self.clientNameTextField.text = self.client.name
                self.clientSurnameTextField.text = self.client.surname
                self.clientPatrynomicTextField.text = self.client.patronymic
                self.clientEmailTextField.text = self.client.email


                
                
                self.clientNameTextField.isEnabled = false
                self.clientNameTextField.borderStyle = .none
                self.clientSurnameTextField.isEnabled = false
                self.clientSurnameTextField.borderStyle = .none
                self.clientPatrynomicTextField.isEnabled = false
                self.clientPatrynomicTextField.borderStyle = .none
                self.clientEmailTextField.isEnabled = false
                self.clientEmailTextField.borderStyle = .none
                
                
                self.editBarButton.title = "Править"
            }))
            
            self.present(alert, animated: true, completion: {
                
            })
            
            
            
        }
    }
    
    @IBAction func didPressDeleteClient(_ sender: UIButton) {
    
        let uid = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let alert = UIAlertController(title: "Удалить?", message: "Вы действительно хотите удалить клиента?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { (_) in
            ref.child("\(uid ?? " ")/clients/\(self.client.makeInitials())").setValue(nil)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    
    //Mark: - not usable functions (another ways to download pictures)
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.clientImage.image = UIImage(data: data)
            }
        }
    }
}


extension OneClientViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listProcedures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseID)
        
        cell.textLabel?.text = listProcedures[indexPath.row].nameProcedure
        cell.detailTextLabel?.text = listProcedures[indexPath.row].dateProcedure
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (storyboard?.instantiateViewController(withIdentifier: "OneProcedureViewController") as? OneProcedureViewController) != nil else { return }
        performSegue(withIdentifier: "showProceduresDetailFromClient", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProceduresDetailFromClient" {
            if let indexPath = proceduresTableView.indexPathForSelectedRow {
                if let destination = segue.destination as? OneProcedureViewController {
                    destination.procedure = listProcedures[indexPath.row]
                    destination.procedure.initials = navBarNameClient.title ?? ""
                }
            }
        }
        if segue.identifier == "showBigPicture" {
            if let destination = segue.destination as? BigPictureViewController {
                destination.myImage = clientImage.image ?? UIImage()
            }
        }
    }
    
    
}
