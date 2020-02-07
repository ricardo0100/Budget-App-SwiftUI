//
//  AddBeanViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 20/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class AddBeanViewModel: ObservableObject, Identifiable {
  
  @Published var name: String = ""
  @Published var value: Decimal = 0
  @Published var alertMessage: String = ""
  @Published var showAlert: Bool = false
  @Published var dismissModal: Bool = false
  
  private var disposables = Set<AnyCancellable>()
  
  func save() {
    Persistency.createBean(name: name, value: value)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          self.showAlert = true
          self.alertMessage = error.localizedDescription
        default:
          break
        }
      }, receiveValue: {
        self.dismissModal.toggle()
      }).store(in: &disposables)
  }
}
