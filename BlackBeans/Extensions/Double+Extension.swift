//
//  StringFormatter.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 18/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

extension Double {
  
  var toCurrency: String {
    return StringFormatter.currencyFormatter.string(from: NSNumber(value: self)) ?? ""
  }
  
}
