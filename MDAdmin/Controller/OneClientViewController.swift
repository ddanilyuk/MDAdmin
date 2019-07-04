//
//  OneClientViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/30/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase

class OneClientViewController: UIViewController {

    @IBOutlet weak var clientImage: UIImageView!
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var clientSurnameLabel: UILabel!
    @IBOutlet weak var clientPatrynomicLabel: UILabel!
    @IBOutlet weak var navBarNameClient: UINavigationItem!
    
    var initials: String = ""
    var fullData: [String: [String: String]] = [:]
    var nameClient: String = ""
    var surnameClient: String = ""
    var patronymicClient: String = ""
    var imageURLClient: String = ""
    
    @IBAction func didPressBigPicture(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBigPicture" {
            if let destination = segue.destination as? BigPictureViewController {
                destination.myImage = clientImage.image ?? UIImage()
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let uid = Auth.auth().currentUser?.uid
        clientImage.layer.cornerRadius = 75

        navBarNameClient.title = initials
        decodeFullData(initials: initials)
        
        clientNameLabel.text = nameClient
        clientSurnameLabel.text = surnameClient
        clientPatrynomicLabel.text = patronymicClient
        
        //guard let url = URL(string: imageURLClient) else { return }
        //downloadImage(from: url)
        
        clientImage.loadImageUsingCacheWithUrlString(imageURLClient)
        
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
    
    func decodeFullData(initials: String) {
        var arrayArguments: [String: String] = fullData[String(self.initials)] ?? [:]
        print("arrayArguments -> ", arrayArguments)
        nameClient = arrayArguments["name"] ?? ""
        surnameClient = arrayArguments["surname"] ?? ""
        patronymicClient = arrayArguments["patronymic"] ?? ""
        imageURLClient = arrayArguments["imageURL"] ?? ""
    }
    


}
