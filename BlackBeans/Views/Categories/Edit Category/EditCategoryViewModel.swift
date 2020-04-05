//
//  EditCategoryViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

class EditCategoryViewModel: ObservableObject, Identifiable {
  
  @Published var title: String = .empty
  @Published var name: String = .empty
  @Published var alertMessage: String?
  @Published var category: Category? {
    didSet {
      guard let category = category else {
        title = "New Category"
        return
      }
      title = "Edit Category"
      name = category.name ?? .empty
    }
  }
  
  func save() {
    if name.isEmpty {
      alertMessage = "Name should not be empty."
      return
    }
    do {
      try Persistency.shared.createCategory(name: name)
    } catch {
      Log.error(error)
    }
  }
}
