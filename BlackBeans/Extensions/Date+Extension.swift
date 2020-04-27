//
//  Date+Extension.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

extension Date {
  
  var relativeDay: String {
    let formatter = RelativeDateTimeFormatter()
    return formatter.string(for: self) ?? .empty
  }
}
