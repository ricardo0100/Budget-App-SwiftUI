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
  @State var date: Date = Date()
  
  var body: some View {
    let nameField = HStack {
      Image(systemName: "bag")
      TextField("Name", text: $editBeanViewModel.name)
    }
    
    let valueField = HStack {
      Image(systemName: "dollarsign.circle")
      CurrencyTextField(decimalValue: $editBeanViewModel.value)
    }
    
    let isCreditField = Picker(selection: self.$editBeanViewModel.beanType, label: Text("")) {
      Text("Debit").tag(0)
      Text("Credit").tag(1)
    }.pickerStyle(SegmentedPickerStyle())
    
    let accountSelection = AccountSelectionView(selectedAccount: self.$editBeanViewModel.account,
                                                isPresented: self.$isAccountsListPresented
    ).environment(\.managedObjectContext, Persistency.shared.context)
    
    let accountField = NavigationLink(destination: accountSelection, isActive: self.$isAccountsListPresented) {
      HStack {
        Image(systemName: "creditcard")
        Text(self.editBeanViewModel.account?.name ?? "No account")
          .foregroundColor(Color.primary)
          .opacity(self.editBeanViewModel.account == nil ? 0.5 : 1)
      }
    }
    
    let categorySelection = CategorySelectionView(selectedCategory: self.$editBeanViewModel.category,
                                                  isPresented: self.$isCategoriesListPresented
    ).environment(\.managedObjectContext, Persistency.shared.context)
      
    
    let categoryField = NavigationLink(destination: categorySelection,
                                       isActive: self.$isCategoriesListPresented) {
      HStack {
        Image(systemName: "tray.full")
        Text(self.editBeanViewModel.category?.name ?? "No category")
          .foregroundColor(Color.primary)
          .opacity(self.editBeanViewModel.category == nil ? 0.5 : 1)
      }
    }
    
    let effectivationField = DatePicker(selection: self.$date, displayedComponents: [.date]) {
      Image(systemName: "calendar").foregroundColor(Color.primary)
      Text(self.date.fullDateString).foregroundColor(Color.primary)
    }.accentColor(Color.red)
      .foregroundColor(Color.white)
    
    let trailingItem = Button(action: {
      self.isPresented = !self.editBeanViewModel.save()
    }) {
      Text("Save")
    }
    
    let alert = Alert(title: Text(editBeanViewModel.alertMessage))
    
    return
      NavigationView {
        Form {
          isCreditField
          nameField
          valueField
          accountField
          categoryField
          effectivationField
        }
        .alert(isPresented: self.$editBeanViewModel.showAlert) {
          alert
        }.navigationBarTitle("New Bean")
          .navigationBarItems(trailing: trailingItem)
      }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    EditBeanView(editBeanViewModel: EditBeanViewModel(),
                 isPresented: Binding.constant(true))
  }
}
