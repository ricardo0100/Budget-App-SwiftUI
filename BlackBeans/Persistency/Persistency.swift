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
  static func createBean(name: String, value: Decimal) -> AnyPublisher<Void, Error>
}

class Persistency: NSObject {
  
  private static let shared = Persistency()
  
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
  
  static private func saveContext() throws {
    let context = Persistency.viewContext
    if context.hasChanges {
      try context.save()
    }
  }
  
  static func deleteBean(bean: Bean) throws {
    Persistency.viewContext.delete(bean)
    try saveContext()
  }
  
}

extension Persistency: Persistable {
  
  static func createBean(name: String, value: Decimal) -> AnyPublisher<Void, Error> {
    Future<Void, Error> { promise in
      let bean = Bean(context: Persistency.viewContext)
      bean.name = name
      bean.value = NSDecimalNumber(decimal: value)
      bean.creationTimestamp = Date()
      do {
        try Persistency.saveContext()
        promise(.success(()))
      } catch {
        Persistency.viewContext.delete(bean)
        promise(.failure(error))
      }
    }.eraseToAnyPublisher()
  }
  
}
