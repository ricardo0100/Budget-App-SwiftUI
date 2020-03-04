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
  
  @ObservedObject var viewModel = AccountsListViewModel()
  
  @State var isEditAccountPresented: Bool = false
  
  var body: some View {
    let list = List {
      ForEach(accounts, id: \.self) { account in
        NavigationLink(destination: AccountDetailsView(account: account)) {
          Text(account.name ?? .empty)
        }
      }.onDelete {
        guard let index = $0.first  else { return }
        let account = self.accounts[index]
        self.viewModel.deleteAccount(account: account)
      }
    }
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    let primaryButton = Alert.Button.destructive(Text("Yes, delete everything"),
                                                 action: self.viewModel.confirmDeletion)
    
    let deleteAlert = Alert(title: Text("⚠️\nAre you sure you want to delete this account?"),
                            message: Text("All related Beans will be deleted!!!"),
                            primaryButton: primaryButton,
                            secondaryButton: .cancel())
    
    return NavigationView {
      list
        .navigationBarItems(trailing: trailing)
        .navigationBarTitle("Accounts")
        .alert(isPresented: self.$viewModel.isDeleteAlertPresented) {
          deleteAlert
        }.sheet(isPresented: self.$isEditAccountPresented) {
          EditAccountView(viewModel: EditAccountViewModel(), isPresented: self.$isEditAccountPresented)
        }
    }
  }
  
}

