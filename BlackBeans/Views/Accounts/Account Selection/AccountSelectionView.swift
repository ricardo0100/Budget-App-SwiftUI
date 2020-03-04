//
//  AccountSelectionView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AccountSelectionView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.allAccountsFetchRequest)
  private var accounts: FetchedResults<Account>
  
  @Binding var selectedAccount: Account?
  @Binding var isPresented: Bool
  @State var isEditAccountPresented: Bool = false
  
  var body: some View {
    let list = List {
      ForEach(accounts, id: \.self) { account in
        return Button(action: {
          self.selectedAccount = account
          self.isPresented = false
        }) {
          Text(account.name ?? .empty)
        }
      }
    }
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    return list
      .navigationBarItems(trailing: trailing)
      .navigationBarTitle("Accounts")
      .environment(\.managedObjectContext, Persistency.shared.context)
      .sheet(isPresented: self.$isEditAccountPresented) {
        EditAccountView(viewModel: EditAccountViewModel(), isPresented: self.$isEditAccountPresented)
      }
  }
}
