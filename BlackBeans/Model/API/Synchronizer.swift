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
  private static let operationQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.qualityOfService = .userInitiated
    queue.name = "Synchronizer Queue"
    return queue
  }()
  
  static var lastSyncPublisher = CurrentValueSubject<Date, Never>(lastSyncTimestamp)
  
  static var lastSyncTimestamp: Date {
    get {
      return Date(timeIntervalSince1970: 0)
//      let timestamp: Double = UserDefaults.standard.value(forKey: "LAST_SYNC_TIMESTAMP") as? Double ?? 0
//      return Date(timeIntervalSince1970: timestamp)
    }
    set {
      UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: "LAST_SYNC_TIMESTAMP")
      OperationQueue.main.addOperation {
        lastSyncPublisher.send(newValue)
      }
    }
  }
  
  static func synchronize() {
    Log.info("New Synchronization Started")
    cancelables.removeAll()
    status.send(.running)
    createSyncPublisher()
      .subscribe(on: operationQueue)
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
      .flatMap { syncCategory() }
      .flatMap { syncBeans() }
      .eraseToAnyPublisher()
  }
  
  private static func syncAccounts() -> AnyPublisher<Void, Error> {
    Persistency.shared.newAccounts()
      .flatMap { API.post(accounts: $0) }
      .flatMap { Persistency.shared.changedAccounts() }
      .flatMap { API.put(accounts: $0) }
      .flatMap { API.getAccounts(updatedAfter: self.lastSyncTimestamp) }
      .flatMap { Persistency.shared.saveAPIAccounts(accounts: $0) }
      .eraseToAnyPublisher()
  }
  
  private static func syncCategory() -> AnyPublisher<Void, Error> {
    Persistency.shared.newCategories()
      .flatMap { API.post(categories: $0) }
      .flatMap { Persistency.shared.changedCategories() }
      .flatMap { API.put(categories: $0) }
      .flatMap { API.getCategories(updatedAfter: self.lastSyncTimestamp) }
      .flatMap { Persistency.shared.saveAPICategories(categories: $0) }
      .eraseToAnyPublisher()
  }
  
  private static func syncBeans() -> AnyPublisher<Void, Error> {
    Persistency.shared.newBeans()
      .flatMap { API.post(beans: $0) }
      .flatMap { Persistency.shared.changedBeans() }
      .flatMap { API.put(beans: $0) }
      .flatMap { API.getBeans(updatedAfter: self.lastSyncTimestamp) }
      .flatMap { Persistency.shared.saveAPIBeans(beans: $0) }
      .eraseToAnyPublisher()
  }
}
