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
  let accountID: Int64
  let categoryID: Int64?
  var createdTime: TimeInterval
  var lastSavedTime: TimeInterval
  var effectivationTime: TimeInterval
  var isActive: Bool
  
  init(from bean: Bean) {
    id = bean.remoteID
    name = bean.name ?? ""
    value = bean.value?.decimalValue ?? 0
    isCredit = bean.isCredit
    accountID = bean.account?.remoteID ?? 0
    categoryID = bean.category?.remoteID
    createdTime = bean.createdTime?.timeIntervalSince1970 ?? 0
    lastSavedTime = bean.lastSavedTime?.timeIntervalSince1970 ?? 0
    effectivationTime = bean.effectivationTime?.timeIntervalSince1970 ?? 0
    isActive = bean.isActive
  }
}
