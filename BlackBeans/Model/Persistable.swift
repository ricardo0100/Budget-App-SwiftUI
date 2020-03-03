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
  
  /// Returns a Fetch Request with all beans ordered by creation date
  var allBeansFetchRequest: NSFetchRequest<Bean> { get }
  
  /// Create a new bean
  func createBean(name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  /// Deletes a bean
  func deleteBean(bean: Bean?) throws
  
  /// Update existing bean
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  // MARK: Accounts
  
  /// Returns a Fetch Request with all accounts ordered by name
  var allAccountsFetchRequest: NSFetchRequest<Account> { get }
  
  /// Create a new Account
  func createAccount(name: String) throws
  
  /// Update existing Account
  func updateAccount(account: Account, name: String) throws
}

extension Persistable {
  
  // MARK: Beans
  
  var allBeansSum: Decimal {
    return creditBeansSum - debitBeansSum
  }
  
  var creditBeansSum: Decimal {
    let expression = NSExpressionDescription()
    expression.expression = NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "value")])
    expression.name = "sum"
    expression.expressionResultType = .decimalAttributeType

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bean")
    fetchRequest.predicate = NSPredicate(format: "isCredit == %@", NSNumber(true))
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
  
  var debitBeansSum: Decimal {
    let expression = NSExpressionDescription()
    expression.expression = NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "value")])
    expression.name = "sum"
    expression.expressionResultType = .decimalAttributeType

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bean")
    fetchRequest.predicate = NSPredicate(format: "isCredit == %@", NSNumber(false))
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.propertiesToFetch = [expression]
    fetchRequest.resultType = .dictionaryResultType
    
    let res = try! context.fetch(fetchRequest)[0] as? [String: NSDecimalNumber]
    let creditSum = (res?["sum"] ?? 0).decimalValue
    return creditSum
  }
  
  var allBeansFetchRequest: NSFetchRequest<Bean> {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.sortDescriptors = [NSSortDescriptor(key: "creationTimestamp", ascending: true)]
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
}
