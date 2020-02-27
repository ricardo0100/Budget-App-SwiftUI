//
//  Bean.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

@objc(Bean)
class Bean: NSManagedObject, Identifiable {
  
  @NSManaged var name: String
  @NSManaged var value: NSDecimalNumber
  @NSManaged var creationTimestamp: Date
  @NSManaged var updateTimestamp: Date
  @NSManaged var isCredit: Bool
  
  var toCurrency: String {
    return self.value.decimalValue.toCurrency ?? ""
  }
  
}
