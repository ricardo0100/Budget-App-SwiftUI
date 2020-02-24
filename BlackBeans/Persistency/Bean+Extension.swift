//
//  Bean+Extension.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

extension Bean: Identifiable {
  
  var toCurrency: String {
    return self.value?.decimalValue.toCurrency ?? ""
  }
  
}
