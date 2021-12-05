//
//  AccountsListView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import SwiftUI

struct AccountsListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<Account>
        
    var body: some View {
        VStack {
            if accounts.isEmpty {
                Text("No accounts")
                    .foregroundColor(.gray)
            } else {
                List(accounts) { account in
                    NavigationLink {
                        EditAccountView(viewModel: EditAccountViewModel(account: account))
                    } label: {
                        AccountCell(account: account)
                    }
                }
            }
        }
        .navigationTitle("Accounts")
        .toolbar {
            NavigationLink {
                EditAccountView(viewModel: EditAccountViewModel())
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AccountsListView()
            }
            NavigationView {
                AccountsListView()
            }.preferredColorScheme(.dark)
        }.environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
