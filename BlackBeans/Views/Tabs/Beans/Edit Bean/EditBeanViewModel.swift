//
//  EditBeanViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class EditBeanViewModel: ObservableObject, Identifiable {
  
  @Published var name: String = .empty
  @Published var value: Decimal = 0
  @Published var beanType: Int = 0
  @Published var alertMessage: String = .empty
  @Published var showAlert: Bool = false
  @Published var account: Account? = nil
  @Published var category: Category? = nil
  @Published var editingBean: Bean? = nil {
    didSet {
      name = editingBean?.name ?? .empty
      value = editingBean?.value?.decimalValue ?? 0
      account = editingBean?.account
      category = editingBean?.category
      beanType = (editingBean?.isCredit ?? false) ? 1 : 0
    }
  }
  
  func save() -> Bool {
    guard !name.isEmpty else {
      alertMessage = "Name should not be empty."
      showAlert = true
      return false
    }
    
    guard let account = account else {
      alertMessage = "Select an account."
      showAlert = true
      return false
    }
    
    do {
      if let bean = editingBean {
        try Persistency.shared.updateBean(bean: bean,
                                          name: name,
                                          value: value,
                                          isCredit: beanType == 1,
                                          account: account,
                                          category: category)
      } else {
        _ = try Persistency.shared.createBean(name: name,
                                              value: value,
                                              isCredit: beanType == 1,
                                              account: account,
                                              category: category)
      }
    } catch {
      Log.error(error)
      fatalError()
    }
    
    return true
  }
}
