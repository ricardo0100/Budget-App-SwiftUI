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
  
  /// Returns a Fetch Request  with all beans for the specified request type ordered by creation date
  func beansFetchRequest(for requestType: BeansRequestType) -> NSFetchRequest<Bean>
  
  /// Create a new bean
  func createBean(name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  /// Deletes a bean
  func deleteBean(bean: Bean?) throws
  
  /// Update existing bean
  func updateBean(bean: Bean, name: String, value: Decimal, isCredit: Bool, account: Account) throws
  
  /// Returns the sum of all credit beans according to the request type
  func creditBeansSum(for requestType: BeansRequestType) -> Decimal
  
  /// Returns the sum of all credit beans according to the request type
  func debitBeansSum(for requestType: BeansRequestType) -> Decimal
  
  // MARK: Accounts
  
  /// Returns a fetch request with all accounts ordered by name
  var allAccountsFetchRequest: NSFetchRequest<Account> { get }
  
  /// Create a new Account
  func createAccount(name: String) throws
  
  /// Update existing Account
  func updateAccount(account: Account, name: String) throws
  
  /// Delete an account
  func deleteAccount(account: Account?) throws
  
  // MARK: Category
  
  /// Return a fetch request with all categories ordered by name
  var allCategoryFetchRequest: NSFetchRequest<Category> { get }
  
  /// Create a new Category
  func createCategory(name: String) throws
}
