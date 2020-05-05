//
//  CategoriesListView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct CategoriesListView: View {
  
  @FetchRequest(fetchRequest: Persistency.shared.allCategoryFetchRequest)
  private var categories: FetchedResults<Category>
  
  @State private var isEditCategoryPresented: Bool = false
  
  var body: some View {
    let list = List {
      ForEach(categories, id: \.self) { category in
        NavigationLink(destination: CategoryDetailsView(category: category)) {
          Text(category.name ?? .empty)
        }
      }.onDelete {
        guard let index = $0.first  else { return }
        _ = self.categories[index]
//        self.deleteAccount(account: account)
      }
    }
    
    let trailing = Button(action: {
      self.isEditCategoryPresented = true
    }) {
      Image(systemName: "plus")
    }
    
//    let primaryButton = Alert.Button.destructive(Text("Yes, delete everything"),
//                                                 action: confirmDeletion)
    
//    let deleteAlert = Alert(title: Text("⚠️\nAre you sure you want to delete this account?"),
//                            message: Text("All related Beans will be deleted!!!"),
//                            primaryButton: primaryButton,
//                            secondaryButton: .cancel())
    
    let editCategory = EditCategoryView(viewModel: EditCategoryViewModel())
    
    return NavigationView {
      list
        .navigationBarItems(trailing: trailing)
        .navigationBarTitle("Categories")
//        .alert(item: self.$deletingAccount) { _ in
//          deleteAlert
//        }
        .sheet(isPresented: self.$isEditCategoryPresented) {
          editCategory
        }
    }.tabItem {
        Image(systemName: "tray.full")
        Text("Categories")
    }
  }
}
