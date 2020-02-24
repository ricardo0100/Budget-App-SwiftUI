//
//  Log.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 26/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct Log {
  
  static func debug(_ message: String) {
    print("✔️ \(message)")
  }
  
  static func error(_ error: Error) {
    print("❗️ \(error.localizedDescription)")
  }
  
}
