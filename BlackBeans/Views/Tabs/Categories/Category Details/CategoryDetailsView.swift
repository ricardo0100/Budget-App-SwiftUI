//
//  CategoryDetailsView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct CategoryDetailsView: View {
  
  @State var isEditPresented: Bool = false
  @State var category: Category
  
  var body: some View {
    let trailing = Button(action: {
      self.isEditPresented.toggle()
    }) {
      Text("Edit")
    }
    return Text(category.name ?? .empty)
      .navigationBarItems(trailing: trailing)
      .sheet(isPresented: self.$isEditPresented) {
        EditCategoryView(viewModel: EditCategoryViewModel(category: self.category))
      }
  }
}
