//
//  AddBeanViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

class AddBeanViewModel: ObservableObject, Identifiable {
  
  @Published var name: String = ""
  @Published var value: Decimal = 0
  @Published var errorMessage: String?
  
  func save() {
    guard !name.isEmpty else {
      errorMessage = "Name should not be empty."
      return
    }
    do {
      try Persistency.createBean(name: name, value: value)
    } catch {
      errorMessage = "Error saving Bean: \(error.localizedDescription)"
      Persistency.log(error)
    }
  }

}
