//
//  Clients.swift
//  MDAdmin
//
//  Created by Denis on 6/29/19.
//  Copyright © 2019 Denis Danilyuk. All rights reserved.
//

import UIKit

class Clients {
    private let name: String
    private let surname: String
    private let patronymic: String
    
    init(name: String, surname: String, patronymic: String) {
        self.name = name
        self.surname = surname
        self.patronymic = patronymic   
    }
    
    func makeInitials() -> String {
        return surname + " " + name + " " + patronymic
    }
    
    func getName() -> String {
        return name
    }
    
    func getSurname() -> String {
        return surname
    }
    
    func getPatronymic() -> String {
        return patronymic
    }
}
