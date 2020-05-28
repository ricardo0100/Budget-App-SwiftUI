//
//  User.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 27/05/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct User: Codable {
    let name: String
    let email: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case token
    }
}
