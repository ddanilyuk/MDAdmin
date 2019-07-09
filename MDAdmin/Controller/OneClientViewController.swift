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
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientSurnameLabel: UILabel!
    @IBOutlet weak var clientPatrynomicLabel: UILabel!
    @IBOutlet weak var navBarNameClient: UINavigationItem!
    @IBOutlet weak var proceduresTableView: UITableView!
    
    var initials: String = ""
    var fullData: [String: [String: Any]] = [:]
    var proceduresArray: [String: Any] = [:]
    var nameClient: String = ""
    var surnameClient: String = ""
    var patronymicClient: String = ""
    var imageURLClient: String = ""
    
    
    var newProceduresArray: [Procedure] = []
    
    var client: Client = Client()
    
    
    var reuseID = "newReuseID"
    var listProcedures = [Procedure]()
    
    @IBAction func didPressBigPicture(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        clientImage.layer.cornerRadius = 75

        navBarNameClient.title = client.makeInitials()
        //decodeFullData(initials: initials)
        
        clientNameLabel.text = client.name
        clientSurnameLabel.text = client.surname
        clientPatrynomicLabel.text = client.patronymic
        
        print(client.procedures)
        listProcedures = client.procedures
        
        
        
        self.listProcedures = self.listProcedures.sorted(by: {$0.dateProcedure > $1.dateProcedure})
        self.proceduresTableView.reloadData()
        
        //Mark: - another way to download image
        //guard let url = URL(string: imageURLClient) else { return }
        //downloadImage(from: url)
        
        //Mark: - another way to download image with caching
        //clientImage.loadImageUsingCacheWithUrlString(client.imageURL)
        clientImage.image = ImageStorage.getClientImage(client: client, imageView: clientImage)
        
        proceduresTableView.delegate = self
        proceduresTableView.dataSource = self
    }
    
    
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
