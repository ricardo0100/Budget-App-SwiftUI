//
//  AlertMessage.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 23/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

class AlertMessage: Identifiable {
  
  let message: String
  
  init(message: String) {
    self.message = message
  }
}
