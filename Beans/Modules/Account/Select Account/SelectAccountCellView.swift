//
//  SelectAccountCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import SwiftUI

struct SelectAccountCellView: View {
    
    @Binding var selectedAccount: Account?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationLink {
            AccountSelectionListView(selectedAccount: $selectedAccount)
        } label: {
            if let account = selectedAccount {
                HStack {
                    Circle()
                        .foregroundColor(Color.from(hex: account.color))
                        .frame(width: 12, height: 12, alignment: .center)
                        .padding(.horizontal, 6)
                    Text(account.name ?? "")
                }
            } else {
                HStack {
                    Text("Select an account")
                        .foregroundStyle(Color.secondary)
                }
            }
        }
    }
}

struct SelectAccountCell_Previews: PreviewProvider {
    static var accounts: [Account] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Account.fetchRequest())
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    NavigationLink(destination: Text("")) {
                        SelectAccountCellView(selectedAccount: .constant(accounts.first!))
                    }
                    NavigationLink(destination: Text("")) {
                        SelectAccountCellView(selectedAccount: .constant(nil))
                    }
                }
                .navigationTitle("SelectAccountCell")
            }
            
            NavigationView {
                Form {
                    NavigationLink(destination: Text("")) {
                        SelectAccountCellView(selectedAccount: .constant(accounts.first!))
                    }
                    NavigationLink(destination: Text("")) {
                        SelectAccountCellView(selectedAccount: .constant(nil))
                    }
                }
                .navigationTitle("SelectAccountCell")
            }
            .preferredColorScheme(.dark)
        }
    }
}
