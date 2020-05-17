//
//  APIAccount.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct APIAccount: APICodable {
  let id: Int64
  let name: String
  let update: TimeInterval
  let creation: TimeInterval
  let isActive: Bool
  
  init(from account: Account) {
    self.id = account.remoteID
    self.name = account.name ?? ""
    self.update = account.update?.timeIntervalSince1970 ?? 0
    self.creation = account.creation?.timeIntervalSince1970 ?? 0
    self.isActive = account.isActive
  }
}
