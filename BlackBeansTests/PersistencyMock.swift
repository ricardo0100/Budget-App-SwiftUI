//
//  PersistencyMock.swift
//  BlackBeansTests
//
//  Created by Ricardo Gehrke on 26/02/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import CoreData

class PersistencyMock: NSObject, Persistable {
  
  var context: NSManagedObjectContext
  
  override init() {
    let container = NSPersistentContainer(name: "BlackBeans")
    let description = NSPersistentStoreDescription()
    description.type = NSInMemoryStoreType
    description.shouldAddStoreAsynchronously = false
    container.persistentStoreDescriptions = [description]
    container.loadPersistentStores { (description, error) in
      precondition(description.type == NSInMemoryStoreType)
    }
    context = container.viewContext
    super.init()
  }
  
}
