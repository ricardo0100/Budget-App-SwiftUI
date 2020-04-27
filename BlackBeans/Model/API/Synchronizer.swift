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
  
  enum SyncError: Error {
    case network, server, decoder, database, unknown
  }
  
  enum SyncStatus {
    case idle, running, completed, error
  }
  
  static let status = CurrentValueSubject<SyncStatus, Never>(.idle)
  
  private static var cancelables = [AnyCancellable]()
  
  static func synchronize() {
    Log.debug("New Sync Requested")
    cancelables.removeAll()
    status.send(.running)
    createSyncPublisher()
      .receive(on: OperationQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let syncError):
          Log.error("Sync error: \(syncError)")
          status.send(.error)
        case .finished:
          Log.debug("Sync Completed")
          status.send(.completed)
        }
      }) { _ in }
    .store(in: &cancelables)
  }
  
  private static func createSyncPublisher() -> AnyPublisher<Void, SyncError> {
    return syncAccounts()
      .flatMap { _ in self.syncCategories() }
      .flatMap { _ in self.syncBeans() }
      .map { _ in }
      .mapError { error -> SyncError in
        Log.error(error)
        return SyncError.unknown
      }.eraseToAnyPublisher()
  }
  
  private static func syncAccounts() -> AnyPublisher<[Account], Error> {
    return API.getAccounts()
      .tryMap {
        try $0.map {
          if let account = try Persistency.shared.account(with: $0.id) {
            try Persistency.shared.updateAccount(account: account,
                                                 name: $0.name,
                                                 remoteID: nil)
            return account
          } else {
            return try Persistency.shared.createAccount(name: $0.name,
                                                        remoteID: $0.id)
          }
        }
    }.eraseToAnyPublisher()
  }
  
  private static func syncCategories() -> AnyPublisher<[Category], Error> {
    return API.getCategories()
      .tryMap {
        try $0.map {
          if let category = try Persistency.shared.category(with: $0.id) {
            try Persistency.shared.updateCategory(category: category,
                                                  name: $0.name,
                                                  remoteID: nil)
            return category
          } else {
            return try Persistency.shared.createCategory(name: $0.name,
                                                         remoteID: $0.id)
          }
        }
    }.eraseToAnyPublisher()
  }
  
  private static func syncBeans() -> AnyPublisher<[Bean], Error> {
    return API.getBeans()
      .tryMap {
        try $0.map {
          guard let account = try Persistency.shared.account(with: $0.accountID) else {
            throw SyncError.database
          }
          let category = try Persistency.shared.category(with: $0.categoryID)
          
          if let bean = try Persistency.shared.bean(with: $0.id) {
            try Persistency.shared.updateBean(bean: bean,
                                              name: $0.name,
                                              value: $0.value,
                                              isCredit: $0.isCredit,
                                              remoteID: $0.id,
                                              account: account,
                                              category: category)
            return bean
          } else {
            return try Persistency.shared.createBean(name: $0.name,
                                                     value: $0.value,
                                                     isCredit: $0.isCredit,
                                                     remoteID: $0.id,
                                                     account: account,
                                                     category: category)
          }
        }
    }.eraseToAnyPublisher()
  }
}
