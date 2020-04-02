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
    
    let list = BeansListView(type: .forAccount(account: account))
    
    let debits: Decimal = Persistency.shared.debitBeansSum(for: account)
    let credits: Decimal = Persistency.shared.creditBeansSum(for: account)
    let sum = credits - debits
    
    let total = VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text("Debits:")
        Spacer()
        Text(debits.toCurrency ?? "").foregroundColor(.red)
      }
      HStack {
        Text("Credits:")
        Spacer()
        Text(credits.toCurrency ?? "").foregroundColor(.green)
      }
      HStack {
        Text("Total:").bold()
        Spacer()
        Text(sum.toCurrency ?? .empty)
          .bold()
          .foregroundColor(sum > 0 ? Color.green : Color.red)
      }
    }.padding()
    
    let trailing = Button(action: {
      self.isEditAccountPresented = true
    }) {
      Text("Edit")
    }
    
    return VStack {
      list
      total
    }
    .navigationBarTitle(account.name ?? .empty)
      .navigationBarItems(trailing: trailing)
      .sheet(isPresented: self.$isEditAccountPresented) {
        return EditAccountView(viewModel: EditAccountViewModel(account: self.account),
                               isPresented: self.$isEditAccountPresented)
    }
  }
}
