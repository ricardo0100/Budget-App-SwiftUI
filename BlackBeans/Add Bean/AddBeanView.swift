//
//  AddBeanView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 17/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AddBeanView: View {
  
  @State var viewModel: AddBeanViewModel = AddBeanViewModel()
  
  @Binding var isShowing: Bool
  
  var body: some View {
    let nameField = TextField("Name", text: $viewModel.name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    
    let valueField = CurrencyTextField(decimalValue: $viewModel.value)
    
    let spacer = Spacer().layoutPriority(1)
    
    let trailingItem = Button(action: viewModel.save) {
      Text("Save")
    }
    
    return NavigationView {
      VStack {
        nameField
        valueField
        spacer
        Text(viewModel.value.toCurrency ?? "")
      }
      .padding()
      .navigationBarTitle("New Bean")
      .navigationBarItems(trailing: trailingItem)
      .alert(isPresented: $viewModel.showAlert) {
        Alert(title: Text("Hey!"), message: Text(viewModel.alertMessage))
      }
    }
  }
}
