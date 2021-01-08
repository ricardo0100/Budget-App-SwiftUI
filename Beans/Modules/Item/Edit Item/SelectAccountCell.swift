//
//  SelectAccountCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import SwiftUI

struct SelectAccountCell: View {
    
    @ObservedObject var account: Account
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(Color.from(hex: account.color))
                .frame(width: 16, height: 16, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(account.name ?? "")
        }
    }
}

struct SelectAccountCell_Previews: PreviewProvider {
    static var accounts: [Account] {
        let context = PersistenceController.preview.container.viewContext
        return try! context.fetch(Account.fetchRequest())
    }
    
    static var previews: some View {
        SelectAccountCell(account: accounts.first!)
    }
}
