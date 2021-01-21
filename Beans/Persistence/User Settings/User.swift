//
//  User.swift
//  Beans
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import Foundation

struct User: Decodable {
    let name: String
    let email: String
    let token: String
}