//
//  EditAccountViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class EditAccountViewModel: ObservableObject, Identifiable {
  
  @Published var name: String = ""
  @Published var isAlertPresented: Bool = false
  @Published var alertMessage: String = ""
  @Published var editingAccount: Account? {
    didSet {
      name = editingAccount?.name ?? ""
    }
  }
  
  init(account: Account? = nil) {
    editingAccount = account
  }
  
  func save() -> Bool {
    guard !name.isEmpty else {
      alertMessage = "Name should not be empty."
      isAlertPresented = true
      return false
    }
    
    do {
      if let account = editingAccount {
        try Persistency.shared.updateAccount(account: account, name: name)
      } else {
        try Persistency.shared.createAccount(name: name)
      }
      return true
    } catch {
      Log.error(error)
      fatalError()
    }
  }
  
}
