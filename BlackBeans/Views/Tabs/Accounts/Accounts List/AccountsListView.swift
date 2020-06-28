//
//  AccountsListView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AccountsListView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.activeAccountsFetchRequest())
  private var accounts: FetchedResults<Account>
  
  @State private var isEditAccountPresented: Bool = false
  @State private var deletingAccount: Account?
  
  var body: some View {
    
    let list = List {
      ForEach(accounts, id: \.self) { account in
        NavigationLink(destination: AccountDetailsView(account: account)) {
          Text(account.name ?? .empty)
        }
      }.onDelete {
        guard let index = $0.first  else { return }
        let account = self.accounts[index]
        self.deleteAccount(account: account)
      }
    }
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    let primaryButton = Alert.Button.destructive(Text("Yes, delete everything"),
                                                 action: confirmDeletion)
    
    let deleteAlert = Alert(title: Text("⚠️\nAre you sure you want to delete this account?"),
                            message: Text("All related Beans will be deleted!!!"),
                            primaryButton: primaryButton,
                            secondaryButton: .cancel())
    
    let editAccount = EditAccountView(viewModel: EditAccountViewModel(),
                                      isPresented: self.$isEditAccountPresented)
    
    return NavigationView {
      list
        .navigationBarItems(trailing: trailing)
        .navigationBarTitle("Accounts")
        .alert(item: self.$deletingAccount) { _ in
          deleteAlert
      }.sheet(isPresented: self.$isEditAccountPresented) {
        editAccount
      }
    }.tabItem {
      Image(systemName: "creditcard")
      Text("Accounts")
    }
  }
  
  private func deleteAccount(account: Account) {
    guard account.beans?.count == 0 else {
      deletingAccount = account
      return
    }
    do {
      try Persistency.shared.delete(object: account)
    } catch {
      Log.error("Error deleting acount: \(error.localizedDescription)")
    }
  }
  
  private func confirmDeletion() {
    guard let account = deletingAccount else { return }
    do {
      try Persistency.shared.delete(object: account)
    } catch {
      Log.error("Error deleting acount: \(error.localizedDescription)")
    }
  }
}

struct AccountsListView_Previews: PreviewProvider {
  static var previews: some View {
    AccountsListView()
        .environment(\.managedObjectContext, Persistency.shared.context)
  }
}
