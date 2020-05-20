//
//  APICategory.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 15/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct APICategory: APICodable {
  let id: Int64
  let name: String
  var lastSavedTime: TimeInterval
  var createdTime: TimeInterval
  var isActive: Bool
  
  init(from category: Category) {
    self.id = category.remoteID
    self.name = category.name ?? ""
    self.lastSavedTime = category.lastSavedTime?.timeIntervalSince1970 ?? 0
    self.createdTime = category.createdTime?.timeIntervalSince1970 ?? 0
    self.isActive = category.isActive
  }
}
