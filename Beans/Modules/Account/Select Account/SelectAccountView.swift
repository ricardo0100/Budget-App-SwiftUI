//
//  SelectAccountView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 24/03/21.
//

import SwiftUI

struct SelectAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
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
                Button(action: {
                    selectedAccountIndex = accounts.firstIndex { $0 == account }
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(account.name ?? "")
                        Circle()
                            .foregroundColor(Color.from(hex: account.color))
                            .frame(width: 10, height: 10, alignment: .center)
                        Spacer()
                    }
                })
            }
        }
        .navigationTitle("Select an account")
        .navigationBarItems(
            trailing: Button("New", action: {
            newAccount = Account(context: viewContext)
        }))
        .sheet(
            item: $newAccount,
            onDismiss: {
                print("🏳️‍🌈")
            },
            content: { _ in
                EditAccountView(viewModel: EditAccountViewModel(account: $newAccount))
            })
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
