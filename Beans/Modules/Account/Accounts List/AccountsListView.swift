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
    @State var editAccount: Account?
        
    var body: some View {
        NavigationView {
            VStack {
                if accounts.isEmpty {
                    Text("No accounts")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(accounts) { account in
                                Button(action: {
                                    editAccount = account
                                }) {
                                    AccountCell(account: account)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                Button(action: {
                    editAccount = Account(context: viewContext)
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $editAccount) { model in
            EditAccountView(viewModel: EditAccountViewModel(account: $editAccount))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
            .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
