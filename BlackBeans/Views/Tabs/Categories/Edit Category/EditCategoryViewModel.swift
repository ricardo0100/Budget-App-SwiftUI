//
//  EditCategoryViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

class EditCategoryViewModel: ObservableObject, Identifiable {
  
  @Published var title: String = "New Category"
  @Published var name: String = .empty
  @Published var alertMessage: String?
  @Published var category: Category? {
    didSet {
      title = "Edit Category"
      name = category?.name ?? .empty
    }
  }
  
  init(category: Category? = nil) {
    self.category = category
  }
  
  func save() {
    if name.isEmpty {
      alertMessage = "Name should not be empty."
      return
    }
    do {
      if let category = category {
        try Persistency.shared.updateCategory(category: category, name: name)
      } else {
        _ = try Persistency.shared.createCategory(name: name)
      }
    } catch {
      Log.error(error)
    }
  }
}
