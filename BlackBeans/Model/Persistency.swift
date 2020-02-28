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
  
  static let shared = Persistency(type: NSSQLiteStoreType)
  
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
  
  init(type: String) {
    super.init()
    if type == NSSQLiteStoreType {
      loadSQLiteStore()
    } else {
      loadInMemoryStore()
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
  
  private func loadInMemoryStore() {
    persistentContainer = createContainer()
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    persistentContainer.persistentStoreDescriptions = [description]
    persistentContainer.loadPersistentStores { (description, error) in
      precondition(description.type == NSInMemoryStoreType)
    }
  }
  
  private func createContainer() -> NSPersistentContainer {
    NSPersistentContainer.init(name: Persistency.modelName, managedObjectModel: Persistency.model)
  }
  
}
