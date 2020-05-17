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
  
  static let status = CurrentValueSubject<SyncStatus, Never>(.idle)
  
  enum SyncStatus {
    case idle, running, completed, error
  }
  
  private static var cancelables = [AnyCancellable]()
  
  static var lastSyncPublisher = CurrentValueSubject<Date, Never>(lastSyncTimestamp)
  
  static var lastSyncTimestamp: Date {
    get {
      let timestamp: Double = UserDefaults.standard.value(forKey: "LAST_SYNC_TIMESTAMP") as? Double ?? 0
      return Date(timeIntervalSince1970: timestamp)
    }
    set {
      UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: "LAST_SYNC_TIMESTAMP")
      lastSyncPublisher.send(newValue)
    }
  }
  
  static func synchronize() {
    Log.info("New Synchronization Requested")
    cancelables.removeAll()
    status.send(.running)
    createSyncPublisher()
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let syncError):
          Log.error(syncError)
          status.send(.error)
        case .finished:
          Log.info("Synchronization Completed")
          lastSyncTimestamp = Date()
          status.send(.completed)
        }
        status.send(.idle)
      }) { _ in }
    .store(in: &cancelables)
  }
  
  private func updateLastSyncTimestamp() {
    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "LAST_SYNC_TIMESTAMP")
  }
  
  private static func createSyncPublisher() -> AnyPublisher<Void, Error> {
    return syncAccounts()
      .eraseToAnyPublisher()
  }
}

// MARK: Accounts

extension Synchronizer {
  
  private static func syncAccounts() -> AnyPublisher<Void, Error> {
    Persistency.shared.newAccounts()
      .flatMap { API.postAccounts(accounts: $0) }
      .flatMap { Persistency.shared.changedAccounts() }
      .flatMap { API.putAccounts(accounts: $0) }
      .flatMap { API.getAccounts(updatedAfter: self.lastSyncTimestamp) }
      .flatMap { Persistency.shared.saveAPIAccounts(accounts: $0) }
      .eraseToAnyPublisher()
  }
}
