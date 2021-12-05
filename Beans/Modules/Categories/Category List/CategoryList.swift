//
//  CategoryList.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 25/11/21.
//

import SwiftUI

struct CategoryList: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemCategory.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<ItemCategory>
    
    var body: some View {
        VStack {
            if categories.isEmpty {
                Text("No categories")
                    .foregroundColor(.secondary)
            } else {
                List(categories) { category in
                    NavigationLink {
                        EditCategoryView(viewModel: EditCategoryViewModel(category: category))
                    } label: {
                        CategoryCell(category: category)
                    }
                }
            }
        }
        .navigationTitle("Categories")
        .toolbar {
            NavigationLink {
                EditCategoryView(viewModel: EditCategoryViewModel())
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct CategoriesList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryList()
                .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
            CategoryList()
                .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
                .preferredColorScheme(.dark)
            CategoryList()
                .environment(\.managedObjectContext, CoreDataController.shared.container.viewContext)
            CategoryList()
                .environment(\.managedObjectContext, CoreDataController.shared.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
