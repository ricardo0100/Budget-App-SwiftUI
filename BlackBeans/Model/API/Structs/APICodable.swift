//
//  APICodable.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 18/06/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

protocol APICodable: Codable {
    var id: Int64 { get }
    var createdTime: TimeInterval { get }
    var lastSavedTime: TimeInterval { get }
    var isActive: Bool { get }
}
