//
//  AccountSelectionView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct AccountSelectionView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.activeAccountsFetchRequest())
  private var accounts: FetchedResults<Account>
  
  @Binding var selectedAccount: Account?
  @Binding var isPresented: Bool
  
  var body: some View {
    return List {
      ForEach(accounts, id: \.self) { account in
        Button(action: {
          self.selectedAccount = account
          self.isPresented = false
        }) {
          Text(account.name ?? .empty)
        }
      }
    }.navigationBarTitle("Select Account")
  }
}
