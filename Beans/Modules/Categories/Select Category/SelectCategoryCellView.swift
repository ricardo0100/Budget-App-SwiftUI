//
//  SelectCategoryCellView.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 06/12/21.
//

import SwiftUI

struct SelectCategoryCellView: View {
    
    @Binding var selectedCategory: ItemCategory?
    
    var body: some View {
        NavigationLink {
            SelectCategoryListView(selectedCategory: $selectedCategory)
        } label: {
            if let category = selectedCategory {
                HStack {
                    Image(systemName: category.symbol ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 2)
                    Text(category.name ?? "")
                }
            } else {
                Text("Select a category")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct SelectCategoryCellView_Previews: PreviewProvider {
    
    static var categories: [ItemCategory] {
        let context = CoreDataController.preview.container.viewContext
        return try! context.fetch(ItemCategory.fetchRequest())
    }
    
    static var previews: some View {
        Form {
            SelectCategoryCellView(selectedCategory: .constant(nil))
            SelectCategoryCellView(selectedCategory: .constant(categories.first!))
        }
    }
}
