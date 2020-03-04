//
//  AccountDetailsView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AccountDetailsView: View {

  
  
  @State var account: Account
  @State var isEditAccountPresented: Bool = false
  
  var body: some View {
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Text("Edit")
    }
    
    return Text(account.name ?? .empty)
      .navigationBarTitle(account.name ?? .empty)
      .navigationBarItems(trailing: trailing)
      .sheet(isPresented: self.$isEditAccountPresented) {
        return EditAccountView(viewModel: EditAccountViewModel(account: self.account),
                               isPresented: self.$isEditAccountPresented)
    }
  }
}
