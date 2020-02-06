//
//  StringFormatter.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 18/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct StringFormatter {
  
  static var currency: NumberFormatter {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2
    return formatter
  }
  
}
