//
//  AccountCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 09/12/20.
//

import SwiftUI

struct AccountCell: View {
    
    @ObservedObject var account: Account
    
    var body: some View {
        let accountColor = Color.from(hex: account.color) ?? .gray
        return ZStack {
            Rectangle()
                .foregroundColor(accountColor.opacity(0.15))
                .cornerRadius(12.0)
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(account.name ?? "")
                        .font(.title3)
                        .foregroundColor(accountColor.darker(by: 0.25))
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(account.sum().toCurrency() ?? "")
                            .font(.headline)
                            .foregroundColor(Color.currencyGreen)
                        Text("Last activity 5 min ago")
                            .foregroundColor(.gray)
                            .font(.caption2)
                    }
                }
                Spacer()
                if !account.recentItems().isEmpty {
                    HStack {
                        Rectangle()
                            .frame(width: 2)
                            .foregroundColor(accountColor)
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Last items:")
                                .foregroundColor(Color.black.opacity(0.5))
                            
                            VStack(alignment: .leading) {
                                ForEach(account.recentItems(), id: \.self) { item in
                                    HStack {
                                        Text(item.name ?? "")
                                        Spacer()
                                        Text(item.value?.toCurrency() ?? "")
                                            .font(.caption)
                                            .foregroundColor(Color.currencyRed)
                                    }
                                }
                            }
                        }.font(.caption)
                    }
                }
            }.padding()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
    }
}

struct AccountCell_Previews: PreviewProvider {
    
    static var accounts: [Account] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Account.fetchRequest())
    }
    
    static var previews: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(accounts, id: \.self) { account in
                        AccountCell(account: account)
                    }
                }
            }
            .navigationTitle("Accounts")
        }
    }
}
