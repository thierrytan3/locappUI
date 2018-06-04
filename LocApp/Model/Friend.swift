//
//  Friend.swift
//  LocApp
//
//  Created by TAN Thierry on 02/06/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

class Friend {
    
    var userId : Int
    var lastName: String
    var firstName: String
    var email: String
    
    init(userId: Int, lastName: String, firstName: String, email: String) {
        self.userId = userId
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
    }
    
}
