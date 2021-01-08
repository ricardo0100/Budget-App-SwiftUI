//
//  AccountsView.swift
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
    
    @State var editAccountModelBinding: EditAccountModel? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                if accounts.isEmpty {
                    Text("No accounts")
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(accounts) { account in
                            HStack(alignment: .center) {
                                Circle()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(Color.from(hex: account.color))
                                Text(account.name ?? "")
                            }
                        }
                    }
                }
            }.toolbar {
                Button(action: {
                    editAccountModelBinding = EditAccountModel()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(item: $editAccountModelBinding) { model in
            EditAccountView(viewModel: EditAccountViewModel(modelBinding: $editAccountModelBinding))
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
