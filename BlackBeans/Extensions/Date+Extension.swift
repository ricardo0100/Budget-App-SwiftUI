//
//  Date+Extension.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

extension Date {
  
  var relativeDayString: String {
    let formatter = RelativeDateTimeFormatter()
    return formatter.string(for: self) ?? .empty
  }
  
  var fullDateString: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .full
    formatter.timeStyle = .none
    return formatter.string(from: self)
  }
}
