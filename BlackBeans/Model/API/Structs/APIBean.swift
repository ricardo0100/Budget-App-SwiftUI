//
//  APIBean.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct APIBean: APICodable {
  let id: Int64
  let name: String
  let value: Decimal
  let isCredit: Bool
  let accountID: Int
  let categoryID: Int
  var createdTime: TimeInterval
  var lastSavedTime: TimeInterval
  var isActive: Bool
}
