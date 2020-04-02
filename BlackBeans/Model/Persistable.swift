//
//  Persistable.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 26/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

protocol Persistable {
  
  /// Default Context
  var context: NSManagedObjectContext { get }
  
  // MARK: Beans
  
  /// Returns the sum of all credit - debit beans values
  var allBeansSum: Decimal { get }
  
  /// Returns the sum of all credit beans values
  var creditBeansSum: Decimal { get }
  
  /// Returns the sum of all debit beans values
  var debitBeansSum: Decimal { get }
  
  /// Returns a Fetch Request  with all beans for the specified type ordered by creation date
  func beansFetchRequest(type: BeansListType) -> NSFetchRequest<Bean>
  
  /// Create a new bean
  func createBean(name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  /// Deletes a bean
  func deleteBean(bean: Bean?) throws
  
  /// Update existing bean
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  /// Returns the sim of all credit beans of the account
  func creditBeansSum(for account: Account) -> Decimal
  
  /// Returns the sim of all credit beans of the account
  func debitBeansSum(for account: Account) -> Decimal
  
  // MARK: Accounts
  
  /// Returns a Fetch Request with all accounts ordered by name
  var allAccountsFetchRequest: NSFetchRequest<Account> { get }
  
  /// Create a new Account
  func createAccount(name: String) throws
  
  /// Update existing Account
  func updateAccount(account: Account, name: String) throws
  
  /// Delete an account
  func deleteAccount(account: Account?) throws
}

extension Persistable {
  
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
  
  func beansFetchRequest(type: BeansListType) -> NSFetchRequest<Bean> {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.sortDescriptors = [NSSortDescriptor(key: "creationTimestamp", ascending: true)]
    switch type {
    case .all:
      break
    case .forAccount(let account):
      fetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Bean.account), account)
    }
    return fetch
  }
  
  func createBean(name: String, value: Decimal, isCredit: Bool, account: Account) throws {
    let bean = Bean(context: context)
    bean.creationTimestamp = Date()
    bean.updateTimestamp = Date()
    bean.name = name
    bean.account = account
    bean.value = NSDecimalNumber(decimal: value)
    bean.isCredit = isCredit
    try context.save()
  }
  
  func deleteBean(bean: Bean?) throws {
    guard let bean = bean else { return }
    context.delete(bean)
    try context.save()
  }
  
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, account: Account) throws {
    bean.name = name
    bean.value = NSDecimalNumber(decimal: value)
    bean.updateTimestamp = Date()
    bean.isCredit = isCredit
    bean.account = account
    try context.save()
  }
  
  func creditBeansSum(for account: Account) -> Decimal {
    return sumOfBeans(account: account, isCredit: true)
  }
  
  func debitBeansSum(for account: Account) -> Decimal {
    return sumOfBeans(account: account, isCredit: false)
  }
  
  // MARK: Accounts
  
  var allAccountsFetchRequest: NSFetchRequest<Account> {
    let fetch = NSFetchRequest<Account>(entityName: "Account")
    fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    return fetch
  }
  
  func createAccount(name: String) throws {
    let account = Account(context: context)
    account.name = name
    try context.save()
  }
  
  func updateAccount(account: Account, name: String) throws {
    account.name = name
    try context.save()
  }
  
  func deleteAccount(account: Account?) throws {
    guard let account = account else { return }
    context.delete(account)
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
