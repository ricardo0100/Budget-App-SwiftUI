//
//  AtomicValue.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

/// Reference: https://www.onswiftwings.com/posts/atomic-property-wrapper/
/// and https://www.objc.io/blog/2018/12/18/atomic-variables/

import Foundation

@propertyWrapper
struct Atomic<T> {

  private let queue = DispatchQueue(label: "Atomic")
  private var value: T

  init(wrappedValue value: T) {
    self.value = value
  }

  var wrappedValue: T {
    get {
      return queue.sync {
        self.value
      }
    }
    set {
      queue.sync {
        self.value = newValue
      }
    }
  }
}
