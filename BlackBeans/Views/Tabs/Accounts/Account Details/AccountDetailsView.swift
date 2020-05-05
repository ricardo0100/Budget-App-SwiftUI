//
//  AccountDetailsView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import CoreData

struct AccountDetailsView: View {
  
  @State var isEditAccountPresented: Bool = false
  
  private var account: Account
  
  init(account: Account) {
    self.account = account
  }
  
  var body: some View {
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Text("Edit")
    }
    
    return VStack(spacing: 0) {
      BeansListView(type: .forAccount(account: account))
      Rectangle()
        .frame(height: 1)
        .foregroundColor(Color.gray.opacity(0.5))
      BeansSumView(type: .forAccount(account: account))
        .background(Color.gray.opacity(0.1))
    }
    .navigationBarTitle(account.name ?? .empty)
    .navigationBarItems(trailing: trailing)
    .sheet(isPresented: self.$isEditAccountPresented) {
      return EditAccountView(viewModel: EditAccountViewModel(account: self.account),
                             isPresented: self.$isEditAccountPresented)
    }
  }
}
