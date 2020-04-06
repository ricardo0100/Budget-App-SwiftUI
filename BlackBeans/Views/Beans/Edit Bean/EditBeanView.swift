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
  @State var isCategoriesListPresented: Bool = false
  @Binding var isPresented: Bool
  
  var body: some View {
    let nameField = TextField("Name", text: $editBeanViewModel.name)
      .textFieldStyle(RoundedBorderTextFieldStyle())
    
    let valueField = CurrencyTextField(decimalValue: $editBeanViewModel.value)
    
    let isCreditField = Toggle(isOn: self.$editBeanViewModel.isCredit) {
      Text("Credit")
    }
    
    let spacer = Spacer().layoutPriority(1)
    
    let accountSelection = AccountSelectionView(selectedAccount: self.$editBeanViewModel.account,
                                                isPresented: self.$isAccountsListPresented
    ).environment(\.managedObjectContext, Persistency.shared.context)
      .navigationBarTitle("Select Account")
    
    let accountField = HStack {
      Image(systemName: "creditcard")
      
      Text(self.editBeanViewModel.account?.name ?? "No account")
        .foregroundColor(Color.primary)
        .opacity(self.editBeanViewModel.account == nil ? 0.5 : 1)
      
      Spacer()
      
      NavigationLink(destination: accountSelection, isActive: self.$isAccountsListPresented) {
        Image(systemName: "square.and.pencil").padding(.trailing, 16)
      }
    }
    
    let categorySelection = CategorySelectionView(selectedCategory: self.$editBeanViewModel.category,
                                                  isPresented: self.$isCategoriesListPresented
    ).environment(\.managedObjectContext, Persistency.shared.context)
      .navigationBarTitle("Select Category")
    
    let categoryField = HStack {
      Image(systemName: "tray.full")
      
      Text(self.editBeanViewModel.category?.name ?? "No category")
        .foregroundColor(Color.primary)
        .opacity(self.editBeanViewModel.category == nil ? 0.5 : 1)
      
      Spacer()
      
      NavigationLink(destination: categorySelection, isActive: self.$isCategoriesListPresented) {
        Image(systemName: "square.and.pencil").padding(.trailing, 16)
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
          categoryField
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
