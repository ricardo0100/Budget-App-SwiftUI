//
//  SelectAccountView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 24/03/21.
//

import SwiftUI

struct SelectAccountView: View {
    
    @State var newAccount: Account?
    @Binding var selectedAccountIndex: Int?
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<Account>
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                SelectAccountCell(account: account)
                    .onTapGesture {
                        selectedAccountIndex = accounts.firstIndex { $0 == account }
                    }
            }
        }
        .navigationTitle("Select an account")
        .navigationBarItems(trailing: Button("New", action: {
            newAccount = Account(context: viewContext)
        }))
        .sheet(item: $newAccount) {
            print("🏳️‍🌈")
        } content: { _ in
            EditAccountView(viewModel: EditAccountViewModel(account: $newAccount))
        }

    }
}

struct SelectAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectAccountView(selectedAccountIndex: .constant(nil))
                .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
        }
    }
}
