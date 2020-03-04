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
  @State var isAccountsListPresented: Bool = false
  @Binding var isPresented: Bool
  
  var body: some View {
    let nameField = TextField("Name", text: $editBeanViewModel.name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    
    let valueField = CurrencyTextField(decimalValue: $editBeanViewModel.value)
    
    let isCreditField = Toggle(isOn: self.$editBeanViewModel.isCredit) {
      Text("Credit")
    }
    
    let spacer = Spacer().layoutPriority(1)
    
    let destination = AccountSelectionView(selectedAccount: self.$editBeanViewModel.account,
      isPresented: self.$isAccountsListPresented).environment(\.managedObjectContext, Persistency.shared.context)
    
    let accountField = HStack {
      Image(systemName: "creditcard")
      Text(self.editBeanViewModel.account?.name ?? "No account")
        .foregroundColor(Color.primary)
        .opacity(self.editBeanViewModel.account == nil ? 0.5 : 1)
      Spacer()
      NavigationLink(destination: destination,
                     isActive: self.$isAccountsListPresented) {
                      Image(systemName: "square.and.pencil")
                      .padding(.trailing, 16)
      }
    }
    
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
          isCreditField
          accountField
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
