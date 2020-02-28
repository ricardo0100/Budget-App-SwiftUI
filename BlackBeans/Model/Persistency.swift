//
//  Persistency.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 12/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

class Persistency: NSObject, Persistable {
  
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
  
}
