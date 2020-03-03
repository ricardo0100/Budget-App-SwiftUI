//
//  AccountsListViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class AccountsListViewModel: ObservableObject, Identifiable {
  
  @Published var isDeleteAlertPresented: Bool = false
  private var deletingAccount: Account?
  
  func deleteAccount(account: Account) {
    guard account.beans?.count == 0 else {
      isDeleteAlertPresented = true
      deletingAccount = account
      return
    }
    
    try? Persistency.shared.deleteAccount(account: account)
  }
  
  func confirmDeletion() {
    guard let account = deletingAccount else { return }
    try? Persistency.shared.deleteAccount(account: account)
  }
  
}
