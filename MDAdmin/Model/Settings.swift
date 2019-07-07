//
//  Settings.swift
//  MDAdmin
//
//  Created by Denis on 6/29/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class Settings {
    private let userDefaults = UserDefaults.standard
    
    static let shared = Settings()
    
    var isLoggedIn: Bool {
        get {
            return userDefaults.bool(forKey: "isLoggedIn")
        }
        set {
            userDefaults.set(newValue, forKey: "isLoggedIn")
        }
    }
}
