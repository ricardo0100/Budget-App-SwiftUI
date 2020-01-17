//
//  CoreData.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 12/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreData: NSObject {
  
  static let shared = CoreData()
  
  var allBeansSum: Double {
    let expression = NSExpressionDescription()
    expression.expression = NSExpression(forFunction: "sum:", arguments:[NSExpression(forKeyPath: "value")])
    expression.name = "sum"
    expression.expressionResultType = .doubleAttributeType

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Bean")
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.propertiesToFetch = [expression]
    fetchRequest.resultType = .dictionaryResultType
    
    let res = try! viewContext.fetch(fetchRequest)[0] as? [String: Double]
    
    return res?["sum"] ?? 0
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
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }
  
  func createMockData() {
    let bean = Bean.init(context: persistentContainer.viewContext)
    bean.name = "Teste"
    bean.creationTimestamp = Date()
    bean.value = 10
    saveContext()
  }
  
}
