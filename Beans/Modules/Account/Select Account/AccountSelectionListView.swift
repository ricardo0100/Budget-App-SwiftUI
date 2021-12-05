//
//  SelectAccountView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 24/03/21.
//

import SwiftUI

struct AccountSelectionListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var selectedAccount: Account?
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Account.name, ascending: true)],
        animation: .default)
    private var accounts: FetchedResults<Account>
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                Button(action: {
                    selectedAccount = account
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Text(account.name ?? "")
                        Circle()
                            .foregroundColor(Color.from(hex: account.color))
                            .frame(width: 10, height: 10, alignment: .center)
                        Spacer()
                    }
                }).buttonStyle(.plain)
            }
        }
        .navigationTitle("Select account")
    }
}

struct SelectAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AccountSelectionListView(selectedAccount: .constant(nil))
            }
            NavigationView {
                AccountSelectionListView(selectedAccount: .constant(nil))
            }.preferredColorScheme(.dark)
        }.environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
