//
//  Log.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 26/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

struct Log {
  
  enum Info {
    case currentThread
  }
  
  static func info(_ message: String) {
    print("✅ \(message)")
  }
  
  static func debug(_ object: Any, infos: [Info] = []) {
    return debug("\(object)", infos: infos)
  }
  
  static func debug(_ message: String, infos: [Info] = []) {
    let infos = infos.map { info -> String in
      switch info {
      case .currentThread:
        return "[Thread: " + (OperationQueue.current?.name ?? "") + "]"
      }
    }
    print("⚠️ \(message) \(infos.joined(separator: " "))")
  }
  
  static func error(_ error: Error) {
    print("❗️ \(error.self) - \(error.localizedDescription)")
  }
  
  static func error(_ message: String) {
    print("❗️ \(message)")
  }
  
}
