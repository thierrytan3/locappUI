//
//  Friend.swift
//  LocApp
//
//  Created by TAN Thierry on 02/06/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

struct Friend : Codable {
    
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    
    init(id: String, username: String, firstName: String , lastName: String, email: String) {
        self.id  = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
    }
    
}
