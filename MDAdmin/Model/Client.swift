//
//  Clients.swift
//  MDAdmin
//
//  Created by Denis on 6/29/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class Client {
    let name: String
    let surname: String
    let patronymic: String
    let imageURL: String
    let procedures: [Procedure]
    
    init(name: String, surname: String, patronymic: String, imageURL: String, procedures: [Procedure]) {
        self.name = name
        self.surname = surname
        self.patronymic = patronymic
        self.imageURL = imageURL
        self.procedures = procedures
    }
    
    init() {
        self.name = ""
        self.surname = ""
        self.patronymic = ""
        self.imageURL = ""
        self.procedures = []
    }
    
    func makeInitials() -> String {
        return surname + " " + name + " " + patronymic
    }
    
    func makeInitialsWithoutSpace() -> String {
        return surname + "_" + name + "_" + patronymic
    }
    
    func getFirstLetter() -> String {
        return String(surname[surname.startIndex])
    }
    
//    func getName() -> String {
//        return name
//    }
//
//    func getSurname() -> String {
//        return surname
//    }
//
//    func getPatronymic() -> String {
//        return patronymic
//    }
}
