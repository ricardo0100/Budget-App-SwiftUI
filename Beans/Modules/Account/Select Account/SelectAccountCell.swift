//
//  SelectAccountCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import SwiftUI

struct SelectAccountCell: View {
    
    @Binding var account: Account?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.fieldBackgroundColor(for: colorScheme))
                .cornerRadius(5)
                .frame(height: 40)
            if let account = account {
                HStack {
                    Text(account.name ?? "")
                    Circle()
                        .foregroundColor(Color.from(hex: account.color))
                        .frame(width: 10, height: 10, alignment: .center)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }.padding()
            } else {
                HStack {
                    Text("Select an account")
                        .foregroundStyle(Color.gray)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }.padding()
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
                VStack {
                    Text("")
                    SelectAccountCell(account: .constant(accounts.first!))
                    SelectAccountCell(account: .constant(nil))
                    Spacer()
                }
                .padding()
                .navigationTitle("SelectAccountCell")
            }
            NavigationView {
                VStack {
                    Text("")
                    SelectAccountCell(account: .constant(accounts.first!))
                    Spacer()
                }
                .padding()
                .navigationTitle("SelectAccountCell")
            }
            .preferredColorScheme(.dark)
        }
    }
}
