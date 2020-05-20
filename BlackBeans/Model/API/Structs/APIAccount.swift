//
//  APIAccount.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct APIAccount: APICodable {
  var name: String
  var id: Int64
  var createdTime: TimeInterval
  var lastSavedTime: TimeInterval
  var isActive: Bool
  
  init(from account: Account) {
    self.id = account.remoteID
    self.name = account.name ?? ""
    self.lastSavedTime = account.lastSavedTime?.timeIntervalSince1970 ?? 0
    self.createdTime = account.createdTime?.timeIntervalSince1970 ?? 0
    self.isActive = account.isActive
  }
}
