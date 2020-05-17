//
//  Persistency.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 12/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData
import Combine

enum BeansRequestType {
  case all
  case forAccount(account: Account)
}

class Persistency: NSObject {
  
  static private let modelName = "BlackBeans"
  
  static let shared = Persistency()
  
  private static var model: NSManagedObjectModel = {
    guard let modelURL = Bundle.main.url(forResource: Persistency.modelName, withExtension: "momd"),
      let model = NSManagedObjectModel(contentsOf: modelURL)else {
        fatalError()
    }
    return model
  }()
  
  private var persistentContainer: NSPersistentContainer!
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  
  init(isTestEnvironment isTest: Bool = false) {
    super.init()
    if isTest {
      loadTestStore()
    } else {
      loadSQLiteStore()
    }
  }
  
  private func loadSQLiteStore() {
    persistentContainer = createContainer()
    persistentContainer.loadPersistentStores { description, error in
      precondition(description.type == NSSQLiteStoreType)
      if let error = error {
        Log.error(error)
        fatalError()
      }
    }
  }
  
  private func loadTestStore() {
    persistentContainer = createContainer()
    let description = NSPersistentStoreDescription()
    description.type = NSSQLiteStoreType
    description.shouldAddStoreAsynchronously = false
    description.url = URL(fileURLWithPath: "/dev/null")
    persistentContainer.persistentStoreDescriptions = [description]
    persistentContainer.loadPersistentStores { (description, error) in
      precondition(description.type == NSSQLiteStoreType)
    }
  }
  
  private func createContainer() -> NSPersistentContainer {
    NSPersistentContainer.init(name: Persistency.modelName, managedObjectModel: Persistency.model)
  }
  
  // MARK: Beans
  
  var allBeansSum: Decimal {
    return creditBeansSum - debitBeansSum
  }
  
  var creditBeansSum: Decimal {
    return sumOfBeans(account: nil, isCredit: true)
  }
  
  var debitBeansSum: Decimal {
    return sumOfBeans(account: nil, isCredit: false)
  }
  
  func beansFetchRequest(for requestType: BeansRequestType) -> NSFetchRequest<Bean> {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.sortDescriptors = [NSSortDescriptor(key: "creation", ascending: true)]
    switch requestType {
    case .all:
      break
    case .forAccount(let account):
      fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Bean.account), account)
    }
    return fetch
  }
  
  func createBean(name: String, value: Decimal, isCredit: Bool, remoteID: Int?, account: Account, category: Category?) throws -> Bean {
    let bean = Bean(context: context)
    bean.creation = Date()
    bean.update = Date()
    bean.name = name
    bean.account = account
    bean.value = NSDecimalNumber(decimal: value)
    bean.isCredit = isCredit
    bean.category = category
    if let id = remoteID {
      bean.remoteID = Int64(id)
    }
    try context.save()
    return bean
  }
  
  func deleteBean(bean: Bean?) throws {
    guard let bean = bean else { return }
    context.delete(bean)
    try context.save()
  }
  
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, remoteID: Int?, account: Account, category: Category?) throws {
    bean.name = name
    bean.value = NSDecimalNumber(decimal: value)
    bean.update = Date()
    bean.isCredit = isCredit
    bean.account = account
    bean.category = category
    if let id = remoteID {
      bean.remoteID = Int64(id)
    }
    try context.save()
  }
  
  func bean(with remoteID: Int) throws -> Bean?  {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Bean.remoteID), Int64(remoteID))
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return try context.fetch(fetch).first
  }
  
  func creditBeansSum(for requestType: BeansRequestType) -> Decimal {
    switch requestType {
    case .all:
      return sumOfBeans(account: nil, isCredit: true)
    case .forAccount(let account):
      return sumOfBeans(account: account, isCredit: true)
    }
  }
  
  func debitBeansSum(for requestType: BeansRequestType) -> Decimal {
    switch requestType {
    case .all:
      return sumOfBeans(account: nil, isCredit: false)
    case .forAccount(let account):
      return sumOfBeans(account: account, isCredit: false)
    }
  }
  
  // MARK: Accounts
  
  func createAllAccountsFetchRequest() -> NSFetchRequest<Account> {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.predicate = NSPredicate(format: "%K == YES",#keyPath(Account.isActive))
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return fetch
  }
  
  func changedAccounts() -> AnyPublisher<[Account], Error> {
    Future<[Account], Error> { promise in
      let request = self.createAllAccountsFetchRequest()
      request.predicate = NSPredicate(format: "%K == YES", #keyPath(Account.shouldSync))
      do {
        let accounts = try self.context.fetch(request)
        promise(.success(accounts))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
  func newAccounts() -> AnyPublisher<[Account], Error> {
    Future<[Account], Error> { promise in
      let request = self.createAllAccountsFetchRequest()
      request.predicate = NSPredicate(format: "%K == NULL", #keyPath(Account.remoteID))
      do {
        let accounts = try self.context.fetch(request)
        promise(.success(accounts))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
  func account(with remoteID: Int64) throws -> Account? {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Account.remoteID), remoteID)
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    do {
      return try context.fetch(fetch).first
    } catch {
      return nil
    }
  }
  
  func createAccount(name: String) throws -> Account {
    let account = Account(context: context)
    account.creation = Date()
    account.update = Date()
    account.shouldSync = true
    account.name = name
    try context.save()
    return account
  }
  
  func updateAccount(account: Account, name: String) throws {
    account.name = name
    account.shouldSync = true
    account.update = Date()
    try context.save()
  }
  
  func deleteAccount(account: Account?) throws {
    guard let account = account else { return }
    account.isActive = false
    account.shouldSync = true
    account.update = Date()
    try context.save()
  }
  
  func saveRemoteID(account: Account, remoteID: Int64) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      account.remoteID = remoteID
      do {
        try self.context.save()
        promise(.success(()))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
  func setSynchronized(accounts: [Account]) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      accounts.forEach {
        $0.shouldSync = false
      }
      do {
        try self.context.save()
        promise(.success(()))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
  func saveAPIAccounts(accounts: [APIAccount]) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      accounts.forEach {
        do {
          let account = try self.account(with: $0.id) ?? Account(context: self.context)
          account.creation = Date(timeIntervalSince1970: $0.creation)
          account.update = Date(timeIntervalSince1970: $0.update)
          account.name = $0.name
          account.shouldSync = false
          account.remoteID = $0.id
          account.isActive = $0.isActive
          try self.context.save()
        } catch {
          promise(.failure(error))
        }
      }
      promise(.success(()))
    }.eraseToAnyPublisher()
  }
  
  func deleteAllAccounts() {
    let accounts = try! self.context.fetch(Persistency.shared.createAllAccountsFetchRequest())
    accounts.forEach {
      try! deleteAccount(account: $0)
    }
  }
  
  // MARK: Category
  
  var allCategoryFetchRequest: NSFetchRequest<Category> {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return fetch
  }
  
  func createCategory(name: String, remoteID: Int?) throws -> Category {
    let category = Category(context: context)
    category.name = name
    if let id = remoteID {
      category.remoteID = Int64(id)
    }
    try context.save()
    return category
  }
  
  func category(with remoteID: Int) throws -> Category? {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Category.remoteID), Int64(remoteID))
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return try context.fetch(fetch).first
  }
  
  func updateCategory(category: Category, name: String, remoteID: Int?) throws {
    category.name = name
    if let id = remoteID {
      category.remoteID = Int64(id)
    }
    try context.save()
  }
  
  // MARK: Private Methods
  
  private func sumOfBeans(account: Account?, isCredit: Bool) -> Decimal {
    let expression = NSExpressionDescription()
    expression.expression = NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "value")])
    expression.name = "sum"
    expression.expressionResultType = .decimalAttributeType

    var predicates = [NSPredicate(format: "isCredit == %@", NSNumber(value: isCredit))]
    if let account = account {
      predicates.append(NSPredicate(format: "account == %@", account))
    }
    let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bean")
    fetchRequest.predicate = predicate
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.propertiesToFetch = [expression]
    fetchRequest.resultType = .dictionaryResultType
    do {
      let res = try context.fetch(fetchRequest).first as? [String: NSDecimalNumber]
      let creditSum = (res?["sum"] ?? 0).decimalValue
      return creditSum
    } catch {
      Log.error(error)
      fatalError()
    }
  }
}
