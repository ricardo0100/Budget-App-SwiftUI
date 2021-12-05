//
//  AccountCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 09/12/20.
//

import SwiftUI

struct AccountCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var account: Account
    
    var body: some View {
        let accountColor = Color.from(hex: account.color)
        let sum = account.sum()
        let sumColor = sum.decimalValue >= 0 ? Color.greenText(for: colorScheme) : Color.redText(for: colorScheme)
        return VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Circle()
                    .frame(width: 12, height: 12)
                    .foregroundColor(accountColor)
                Spacer()
                    .frame(width: 4)
                Text(account.name ?? "")
                Spacer()
                VStack(alignment: .trailing) {
                    Text(sum.toCurrency() ?? "")
                        .foregroundColor(sumColor)
                }
            }
        }
    }
}

struct AccountCell_Previews: PreviewProvider {
    
    static var accounts: [Account] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Account.fetchRequest())
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                List(accounts, id: \.self) { account in
                    AccountCell(account: account)
                }
                .navigationTitle("Accounts")
            }
            NavigationView {
                List(accounts, id: \.self) { account in
                    AccountCell(account: account)
                }
                .navigationTitle("Accounts")
            }
            .preferredColorScheme(.dark)
        }
    }
}
