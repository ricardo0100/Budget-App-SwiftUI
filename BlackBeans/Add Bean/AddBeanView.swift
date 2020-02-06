//
//  AddBeanView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 17/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AddBeanView: View {
    
  @ObservedObject var viewModel: AddBeanViewModel = AddBeanViewModel()
  
  @Binding var isPresenting: Bool
  
  var body: some View {
    
    let nameField = TextField("Name", text: $viewModel.name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    
    let valueField = CurrencyTextField(decimalValue: $viewModel.value)
    
    let leadingNavigationItem = Button("Cancel") {
      self.isPresenting.toggle()
    }
    
    let trailingNavigationItem = Button("Save") {
      self.viewModel.save()
    }
    
    let isAlertPresented = Binding<Bool>(
      get: { self.viewModel.errorMessage != nil },
      set: { _ in self.viewModel.errorMessage = nil }
    )
    
    return NavigationView {
      VStack {
        nameField
        valueField
        Spacer().layoutPriority(1)
      }.padding()
      .navigationBarTitle("New Bean")
      .navigationBarItems(leading: leadingNavigationItem, trailing: trailingNavigationItem)
      .alert(isPresented: isAlertPresented) {
        Alert(title: Text(viewModel.errorMessage ?? .empty))
      }
    }
  }
}
