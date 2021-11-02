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
        HStack() {
            ZStack {
                Circle()
                    .foregroundColor(Color.purple)
                    .frame(width: 32, height: 32)
                Image(systemName: "fork.knife")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.purple)
            }
            Spacer()
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name ?? "").lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color.from(hex: item.account?.color))
                    Text(item.account?.name ?? "")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            VStack {
                Text(item.value?.toCurrency() ?? "")
                    .bold()
            }
        }
    }
}

struct ItemCell_Previews: PreviewProvider {
    
    static var item: Item {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(Item.fetchRequest()).randomElement() as! Item
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ItemCell(item: item)
                    ItemCell(item: item)
                    ItemCell(item: item)
                }.navigationTitle("Items")
            }
            NavigationView {
                List {
                    ItemCell(item: item)
                    ItemCell(item: item)
                    ItemCell(item: item)
                }.navigationTitle("Items")
            }
            .preferredColorScheme(.dark)
        }
    }
}
