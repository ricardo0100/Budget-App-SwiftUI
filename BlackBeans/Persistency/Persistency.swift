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

protocol Persistable {
  /// Returns the sum of all beans values
  static var allBeansSum: Decimal { get }
  
  /// Returns a Fetch Request with all beans ordered by name
  static var allBeansFetchRequest: NSFetchRequest<Bean> { get }
  
  /// Create a new bean
  static func createBean(name: String, value: Decimal) throws
  
  /// Deletes a bean
  static func deleteBean(bean: Bean?) throws
  
  /// Update existing bean
  static func updateBean(bean: Bean, name: String, value: Decimal) throws
}

class Persistency: NSObject {
  
  private static let shared = Persistency()
  
  static var viewContext: NSManagedObjectContext {
    return shared.persistentContainer.viewContext
  }
  
  private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "BlackBeans")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()
  
}

extension Persistency: Persistable {
  
  static var allBeansSum: Decimal {
    let expression = NSExpressionDescription()
    expression.expression = NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "value")])
    expression.name = "sum"
    expression.expressionResultType = .decimalAttributeType

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bean")
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.propertiesToFetch = [expression]
    fetchRequest.resultType = .dictionaryResultType
    
    let res = try! Persistency.viewContext.fetch(fetchRequest)[0] as? [String: NSDecimalNumber]
    
    return (res?["sum"] ?? 0).decimalValue
  }
  
  static var allBeansFetchRequest: NSFetchRequest<Bean> {
    let fetch = NSFetchRequest<Bean>(entityName: "Bean")
    fetch.sortDescriptors = [NSSortDescriptor(key: "value", ascending: true)]
    return fetch
  }
  
  static func createBean(name: String, value: Decimal) throws {
    let bean = Bean(context: Persistency.viewContext)
    bean.creationTimestamp = Date()
    bean.name = name
    bean.value = NSDecimalNumber(decimal: value)
    try Persistency.viewContext.save()
  }
  
  static func deleteBean(bean: Bean?) throws {
    guard let bean = bean else { return }
    Persistency.viewContext.delete(bean)
    try Persistency.viewContext.save()
  }
  
  static func updateBean(bean: Bean, name: String, value: Decimal) throws {
    bean.name = name
    bean.value = NSDecimalNumber(decimal: value)
    try Persistency.viewContext.save()
  }
}
