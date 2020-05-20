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
  
  
  // MARK: Accounts
  
  func activeAccountsFetchRequest() -> NSFetchRequest<Account> {
    activeObjectsFetchRequest()
  }
  
  func newAccounts() -> AnyPublisher<[Account], Error> {
    newObjects()
  }
  
  func changedAccounts() -> AnyPublisher<[Account], Error> {
    changedObjects()
  }
  
  func createAccount(name: String) throws -> Account {
    let account = Account(context: context)
    account.createdTime = Date()
    account.lastSavedTime = Date()
    account.shouldSync = true
    account.name = name
    try context.save()
    return account
  }
  
  func updateAccount(account: Account, name: String) throws {
    account.name = name
    account.shouldSync = true
    account.lastSavedTime = Date()
    try context.save()
  }
  
  func saveAPIAccounts(accounts: [APIAccount]) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      accounts.forEach {
        do {
          let account = try self.accountWith(remoteID: $0.id) ?? Account(context: self.context)
          account.createdTime = Date(timeIntervalSince1970: $0.createdTime)
          account.lastSavedTime = Date(timeIntervalSince1970: $0.lastSavedTime)
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
  
  func accountWith(remoteID: Int64) throws -> Account? {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Account.remoteID), remoteID)
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    do {
      return try context.fetch(fetch).first
    } catch {
      return nil
    }
  }
  
  
  // MARK: Category
  
  func activeCategoriesFetchRequest() -> NSFetchRequest<Category> {
    activeObjectsFetchRequest()
  }
  
  func newCategories() -> AnyPublisher<[Category], Error> {
    newObjects()
  }
  
  func changedCategories() -> AnyPublisher<[Category], Error> {
    changedObjects()
  }
  
  func createCategory(name: String) throws -> Category {
    let category = Category(context: context)
    category.createdTime = Date()
    category.name = name
    try context.save()
    return category
  }
  
  func updateCategory(category: Category, name: String) throws {
    category.name = name
    category.shouldSync = true
    category.lastSavedTime = Date()
    try context.save()
  }
  
  func saveAPICategories(categories: [APICategory]) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      categories.forEach {
        do {
          let category = try self.categoryWith(remoteID: $0.id) ?? Category(context: self.context)
          category.createdTime = Date(timeIntervalSince1970: $0.createdTime)
          category.lastSavedTime = Date(timeIntervalSince1970: $0.lastSavedTime)
          category.name = $0.name
          category.shouldSync = false
          category.remoteID = $0.id
          category.isActive = $0.isActive
          try self.context.save()
        } catch {
          promise(.failure(error))
        }
      }
      promise(.success(()))
    }.eraseToAnyPublisher()
  }
  
  func categoryWith(remoteID: Int64) throws -> Category? {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Account.remoteID), remoteID)
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    do {
      return try context.fetch(fetch).first
    } catch {
      return nil
    }
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
    fetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(Bean.createdTime), ascending: true)]
    switch requestType {
    case .all:
      break
    case .forAccount(let account):
      fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Bean.account), account)
    }
    return fetch
  }
  
  func createBean(name: String, value: Decimal, isCredit: Bool, account: Account, category: Category?) throws -> Bean {
    let bean = Bean(context: context)
    bean.createdTime = Date()
    bean.lastSavedTime = Date()
    bean.effectivationTime = Date()
    bean.name = name
    bean.account = account
    bean.value = NSDecimalNumber(decimal: value)
    bean.isCredit = isCredit
    bean.category = category
    bean.shouldSync = true
    bean.isActive = true
    try context.save()
    return bean
  }
  
  func deleteBean(bean: Bean?) throws {
    guard let bean = bean else { return }
    context.delete(bean)
    try context.save()
  }
  
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, account: Account, category: Category?) throws {
    bean.name = name
    bean.value = NSDecimalNumber(decimal: value)
    bean.lastSavedTime = Date()
    bean.createdTime = Date()
    bean.isCredit = isCredit
    bean.account = account
    bean.category = category
    bean.effectivationTime = Date()
    try context.save()
  }
  
  func beanWith(remoteID: Int64) throws -> Bean?  {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Bean.remoteID), remoteID)
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
  
  func newBeans() -> AnyPublisher<[Bean], Error> {
    newObjects()
  }
  
  func changedBeans() -> AnyPublisher<[Bean], Error> {
    changedObjects()
  }
  
  func saveAPIBeans(beans: [APIBean]) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      beans.forEach {
        do {
          let bean = try self.beanWith(remoteID: $0.id) ?? Bean(context: self.context)
          bean.createdTime = Date(timeIntervalSince1970: $0.createdTime)
          bean.lastSavedTime = Date(timeIntervalSince1970: $0.lastSavedTime)
          bean.name = $0.name
          bean.shouldSync = false
          bean.remoteID = $0.id
          bean.isActive = $0.isActive
          bean.value = NSDecimalNumber(decimal: $0.value)
          bean.isCredit = $0.isCredit
          bean.effectivationTime = Date(timeIntervalSince1970: $0.effectivationTime)
          bean.account = try self.accountWith(remoteID: $0.accountID)
          if let id = $0.categoryID {
            bean.category = try self.categoryWith(remoteID: id)
          } else {
            bean.category = nil
          }
          try self.context.save()
        } catch {
          promise(.failure(error))
        }
      }
      promise(.success(()))
    }.eraseToAnyPublisher()
  }
  
  
  // MARK: Generic Methods
  
  func delete(object: APIEntity?) throws {
    object?.isActive = false
    object?.shouldSync = true
    object?.lastSavedTime = Date()
    try context.save()
  }
  
  
  // MARK: Private Methods
  
  private func activeObjectsFetchRequest<T: APIEntity>() -> NSFetchRequest<T> {
    let fetch = NSFetchRequest<T>(entityName: String(describing: T.self))
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(APIEntity.isActive), true)
    fetch.sortDescriptors = [NSSortDescriptor(key: #keyPath(APIEntity.lastSavedTime), ascending: true)]
    return fetch
  }
  
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
  
  private func changedObjects<T: APIEntity>() -> AnyPublisher<[T], Error> {
    Future<[T], Error> { promise in
      let request = NSFetchRequest<T>(entityName: String(describing: T.self))
      request.sortDescriptors = [NSSortDescriptor(key: #keyPath(APIEntity.lastSavedTime), ascending: true)]
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
        NSPredicate(format: "%K == YES", #keyPath(APIEntity.shouldSync)),
        NSPredicate(format: "%K != nil", #keyPath(APIEntity.remoteID))
      ])
      do {
        let objects = try self.context.fetch(request)
        promise(.success(objects))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
  private func newObjects<T: APIEntity>() -> AnyPublisher<[T], Error> {
    Future<[T], Error> { promise in
      let request = NSFetchRequest<T>(entityName: String(describing: T.self))
      request.sortDescriptors = [NSSortDescriptor(key: #keyPath(APIEntity.lastSavedTime), ascending: true)]
      request.predicate = NSPredicate(format: "%K == NULL", #keyPath(APIEntity.remoteID))
      do {
        let objects = try self.context.fetch(request)
        promise(.success(objects))
      } catch {
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
}
