//
//  Bean+Extension.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

extension Bean {
  
  static func allBeansFetchRequest() -> NSFetchRequest<Bean> {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
    return fetch
  }
  
  var valueWithCurrency: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter.string(from: value ?? 0) ?? ""
  }
  
}
