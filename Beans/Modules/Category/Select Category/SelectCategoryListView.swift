//
//  SelectCategoryListView.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 06/12/21.
//

import SwiftUI

struct SelectCategoryListView: View {
    
    @Binding var selectedCategory: ItemCategory?
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ItemCategory.name, ascending: true)],
        animation: .default)
    private var categories: FetchedResults<ItemCategory>
    
    var body: some View {
        List(categories) { category in
            Button {
                selectedCategory = category
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Image(systemName: category.symbol ?? "")
                        .frame(width: 30)
                    Text(category.name ?? "")
                    Spacer()
                }
            }.buttonStyle(.plain)
        }
    }
}

struct SelectCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SelectCategoryListView(selectedCategory: .constant(nil))
            SelectCategoryListView(selectedCategory: .constant(nil))
                .preferredColorScheme(.dark)
        }.environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
    }
}
