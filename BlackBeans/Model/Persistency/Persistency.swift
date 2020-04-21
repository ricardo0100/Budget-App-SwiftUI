//
//  Persistency.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 12/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

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
    fetch.sortDescriptors = [NSSortDescriptor(key: "creationTimestamp", ascending: true)]
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
    bean.creationTimestamp = Date()
    bean.updateTimestamp = Date()
    bean.name = name
    bean.account = account
    bean.value = NSDecimalNumber(decimal: value)
    bean.isCredit = isCredit
    bean.category = category
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
    bean.updateTimestamp = Date()
    bean.isCredit = isCredit
    bean.account = account
    bean.category = category
    try context.save()
  }
  
  func bean(with remoteId: Int) throws -> Bean?  {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Bean.remoteID), Int64(remoteId))
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
  
  var allAccountsFetchRequest: NSFetchRequest<Account> {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return fetch
  }
  
  func account(with remoteId: Int) throws -> Account? {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Account.remoteID), Int64(remoteId))
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return try context.fetch(fetch).first
  }
  
  func createAccount(name: String, remoteId: Int?) throws -> Account {
    let account = Account(context: context)
    account.name = name
    if let id = remoteId {
      account.remoteID = Int64(id)
    }
    try context.save()
    return account
  }
  
  func updateAccount(account: Account, name: String, remoteId: Int?) throws {
    account.name = name
    if let id = remoteId {
      account.remoteID = Int64(id)
    }
    try context.save()
  }
  
  func deleteAccount(account: Account?) throws {
    guard let account = account else { return }
    context.delete(account)
    try context.save()
  }
  
  // MARK: Category
  
  var allCategoryFetchRequest: NSFetchRequest<Category> {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return fetch
  }
  
  func createCategory(name: String, remoteId: Int?) throws -> Category {
    let category = Category(context: context)
    category.name = name
    if let id = remoteId {
      category.remoteID = Int64(id)
    }
    try context.save()
    return category
  }
  
  func category(with remoteId: Int) throws -> Category? {
    let fetch = NSFetchRequest<Category>(entityName: "Category")
    fetch.predicate = NSPredicate(format: "%K == %d", #keyPath(Category.remoteID), Int64(remoteId))
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return try context.fetch(fetch).first
  }
  
  func updateCategory(category: Category, name: String, remoteId: Int?) throws {
    category.name = name
    if let id = remoteId {
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
