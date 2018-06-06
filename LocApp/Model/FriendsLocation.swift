//
//  FriendsLocation.swift
//  LocApp
//
//  Created by Musa Lheureux on 06/06/2018.
//  Copyright © 2018 LocApp. All rights reserved.
//

import Foundation

struct FriendsLocation: Codable {
    let id: String
    let username: String
    let lastName: String
    let firstName: String
    let user: String
    let latitude: String
    let longitude: String
    let lastUpdate: Date
}

