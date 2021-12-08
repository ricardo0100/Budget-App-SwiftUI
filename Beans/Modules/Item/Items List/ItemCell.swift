//
//  ItemCell.swift
//  Beans
//
//  Created by Ricardo Gehrke on 11/12/20.
//

import SwiftUI

struct ItemCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var item: Item
    
    var body: some View {
        let value = item.value ?? 0
        let valueColor = value.decimalValue >= 0 ? Color.greenText(for: colorScheme) : Color.redText(for: colorScheme)
        HStack {
            Image(systemName: item.category?.symbol ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .opacity(0.6)
            Spacer()
                .frame(width: 16)
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name ?? "")
                    .font(.subheadline)
                    .lineLimit(2)
                HStack(spacing: 4) {
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color.from(hex: item.account?.color))
                    Text(item.account?.name ?? "")
                        .font(.footnote)
                        .fontWeight(.light)
                }
            }
            Spacer()
            Text(value.toCurrency() ?? "")
                .font(.headline)
                .foregroundColor(valueColor)
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    
    static var items: [Item] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Item.fetchRequest())
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                List(items) { item in
                    ItemCell(item: item)
                    ItemCell(item: item)
                    ItemCell(item: item)
                }.navigationTitle("Items")
            }
            NavigationView {
                List(items) { item in
                    ItemCell(item: item)
                    ItemCell(item: item)
                    ItemCell(item: item)
                }.navigationTitle("Items")
            }
            .preferredColorScheme(.dark)
        }
    }
}
