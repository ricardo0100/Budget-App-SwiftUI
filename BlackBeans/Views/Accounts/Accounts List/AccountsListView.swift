//
//  AccountsListView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AccountsListView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.allAccountsFetchRequest)
  private var accounts: FetchedResults<Account>
  
  @State var isEditAccountPresented: Bool = false
  
  var body: some View {
    let list = List {
      ForEach(accounts, id: \.self) { account in
        NavigationLink(destination: AccountDetailsView(account: account)) {
          Text(account.name ?? "")
        }
      }
    }
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    return NavigationView {
      list
        .navigationBarItems(trailing: trailing)
        .navigationBarTitle("Accounts")
        .sheet(isPresented: self.$isEditAccountPresented) {
          EditAccountView(viewModel: EditAccountViewModel(), isPresented: self.$isEditAccountPresented)
        }
    }
  }
}

