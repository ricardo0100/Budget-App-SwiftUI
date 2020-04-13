//
//  Synchronizer.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class Synchronizer {
  
  private var cancelables: [AnyCancellable] = []
  @Atomic private var isRunning = false
  
  func synchronize() {
    if isRunning { return }
    APIManager
      .getAccountsPublisher()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          Log.debug("API Get Accounts completed")
        case .failure(let error):
          Log.error(error)
        }
    }) { accounts in
      for apiAccount in accounts {
        do {
          try Persistency.shared.createAccount(name: apiAccount.name)
        } catch {
          Log.error(error)
        }
      }
    }.store(in: &cancelables)
  }
}
