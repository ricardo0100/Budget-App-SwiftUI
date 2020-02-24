//
//  EditBeanView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 17/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import Combine

struct EditBeanView: View {
  
  @ObservedObject var editBeanViewModel: EditBeanViewModel
  @Binding var isPresented: Bool
  
  var body: some View {
    Log.debug("EditBeanView body")
    let nameField = TextField("Name", text: $editBeanViewModel.name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    
    let valueField = CurrencyTextField(decimalValue: $editBeanViewModel.value)
    
    let spacer = Spacer().layoutPriority(1)
    
    let trailingItem = Button(action: {
      self.isPresented = !self.editBeanViewModel.save()
    }) {
      Text("Save")
    }
    
    let alert = Alert(title: Text(editBeanViewModel.alertMessage))
    
    return
      NavigationView {
        VStack {
          nameField
          valueField
          spacer
        }
        .alert(isPresented: self.$editBeanViewModel.showAlert) {
          alert
        }
        .padding()
        .navigationBarTitle("New Bean")
        .navigationBarItems(trailing: trailingItem)
      }
  }
}
