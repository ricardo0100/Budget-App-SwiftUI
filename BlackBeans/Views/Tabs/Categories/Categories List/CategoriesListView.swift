//
//  CategoriesListView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct CategoriesListView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.activeCategoriesFetchRequest())
  private var categories: FetchedResults<Category>
  
  @State private var deletingCategory: Category?
  @State private var isEditCategoryPresented: Bool = false
  
  var body: some View {
    let list = List {
      ForEach(categories, id: \.self) { category in
        NavigationLink(destination: CategoryDetailsView(category: category)) {
          Text(category.name ?? .empty)
        }
      }.onDelete {
        guard let index = $0.first  else { return }
        self.delete(category: self.categories[index])
      }
    }
    
    let trailing = Button(action: {
      self.isEditCategoryPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    let primaryButton = Alert.Button.destructive(Text("Yes, delete everything"),
                                                 action: confirmDeletion)
    
    let editCategory = EditCategoryView(viewModel: EditCategoryViewModel())
    
    return NavigationView {
      list
        .navigationBarItems(trailing: trailing)
        .navigationBarTitle("Categories")
        .alert(item: self.$deletingCategory) {
          Alert(title: Text("⚠️ Warnin!"),
                message: Text("There are \($0.beans?.count ?? 0) beans related to \($0.name ?? .empty) category. Delete anyway?"),
                primaryButton: primaryButton,
                secondaryButton: .cancel())
        }
        .sheet(isPresented: self.$isEditCategoryPresented) {
          editCategory
        }
    }.tabItem {
        Image(systemName: "tray.full")
        Text("Categories")
    }
  }
  
  private func delete(category: Category?) {
    if category?.beans?.count ?? 0 > 0 {
      deletingCategory = category
    } else {
      try? Persistency.shared.delete(object: category)
    }
  }
  
  private func confirmDeletion() {
    try? Persistency.shared.delete(object: deletingCategory)
  }
}

struct CategoriesListView_Previews: PreviewProvider {
  static var previews: some View {
    CategoriesListView()
  }
}
