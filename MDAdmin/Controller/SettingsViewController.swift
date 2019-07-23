//
//  SettingsViewController.swift
//  MDAdmin
//
//  Created by Denis on 6/22/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn


class SettingsViewController: UITableViewController, GIDSignInUIDelegate {
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent("/images/")
        // check if the url is a directory
        if (try? documentsDirectoryURL.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true {
            print("url is a folder url")
            // lets get the folder files
            var folderSize = 0
            (try? FileManager.default.contentsOfDirectory(at: documentsDirectoryURL, includingPropertiesForKeys: nil))?.lazy.forEach {
                folderSize += (try? $0.resourceValues(forKeys: [.totalFileAllocatedSizeKey]))?.totalFileAllocatedSize ?? 0
            }
            // format it using NSByteCountFormatter to display it properly
            let  byteCountFormatter =  ByteCountFormatter()
            byteCountFormatter.allowedUnits = .useBytes
            byteCountFormatter.countStyle = .file
            let folderSizeToDisplay = byteCountFormatter.string(for: folderSize) ?? ""
            print(folderSizeToDisplay)  // "X,XXX,XXX bytes"
        }
    }
    

    
}
