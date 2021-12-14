//
//  CategoryCell.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 25/11/21.
//

import SwiftUI

struct CategoryCell: View {
    
    @ObservedObject var category: ItemCategory
    
    var body: some View {
        HStack {
            Image(systemName: category.symbol ?? "")
                .frame(width: 32)
            Text(category.name ?? "")
        }
    }
}

struct CategoryCell_Previews: PreviewProvider {
    static var categories: [ItemCategory] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(ItemCategory.fetchRequest())
    }
    
    static var previews: some View {
        Group {
            NavigationView {
                List(categories, id: \.self) { category in
                    CategoryCell(category: category)
                }
                .navigationTitle("Categories")
            }
            NavigationView {
                List(categories, id: \.self) { category in
                    CategoryCell(category: category)
                }
                .navigationTitle("Categories")
            }
            .preferredColorScheme(.dark)
        }
    }
}
