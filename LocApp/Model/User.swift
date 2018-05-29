//
//  User.swift
//  LocApp
//
//  Created by Musa Lheureux on 27/05/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

struct User {
    var lastName: String?
    var firstName: String?
    var email: String?
    var password: String?
    var password2: String?
    
}

extension User {
    
    enum Status {
        case accepted
        case rejected(String)
    }
    
    var status: Status {
        if self.lastName == nil || self.lastName == "" {
            return .rejected("Vous n'avez pas indiqué votre nom !")
        }
        if self.firstName == nil || self.firstName == "" {
            return .rejected("Vous n'avez pas indiqué votre prénom !")
        }
        if self.email == nil || self.email == "" {
            return .rejected("Vous n'avez pas indiqué votre adresse e-mail !")
        }
        if self.password == nil || self.password == "" || self.password != self.password2 {
            if self.password2 == nil || self.password2 == "" || self.password2 != self.password {
                return .rejected("Merci de bien vouloir vérifier et confirmer votre mot de passe.")
            }
        }
        return .accepted
    }
    
}
