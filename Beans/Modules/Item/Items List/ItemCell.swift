//
//  ItemCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 11/12/20.
//

import SwiftUI

struct ItemCell: View {
    
    @ObservedObject var item: Item
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name ?? "")
                Text(item.account?.name ?? "")
                    .font(.footnote)
                    .foregroundColor(Color.from(hex: item.account?.color))
            }
            Spacer()
            Text(item.value?.toCurrency() ?? "")
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    
    static var item: Item {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Item.fetchRequest()).randomElement() as! Item
    }
    
    static var previews: some View {
        NavigationView {
            List {
                ItemCell(item: item)
            }.navigationTitle("Items")
        }
    }
}
