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
  
  @Published var title: String = ""
  @Published var name: String = .empty
  @Published var isAlertPresented: Bool = false
  @Published var alertMessage: String = .empty
  @Published var editingAccount: Account? {
    didSet {
      name = editingAccount?.name ?? .empty
    }
  }
  
  init(account: Account? = nil) {
    editingAccount = account
    title = account == nil ? "New Account" : "Edit Account"
  }
  
  func save() -> Bool {
    guard !name.isEmpty else {
      alertMessage = "Name should not be empty."
      isAlertPresented = true
      return false
    }
    
    do {
      if let account = editingAccount {
        try Persistency.shared.updateAccount(account: account, name: name, remoteId: nil)
      } else {
        _ = try Persistency.shared.createAccount(name: name, remoteId: nil)
      }
      return true
    } catch {
      Log.error(error)
      fatalError()
    }
  }
  
}
