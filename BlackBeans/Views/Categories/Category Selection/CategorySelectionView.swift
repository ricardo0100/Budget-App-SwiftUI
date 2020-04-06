//
//  CategorySelectionView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 06/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct CategorySelectionView: View {
    
  @FetchRequest(fetchRequest: Persistency.shared.allCategoryFetchRequest)
  private var categories: FetchedResults<Category>
  
  @Binding var selectedCategory: Category?
  @Binding var isPresented: Bool
  
  var body: some View {
    return List {
      ForEach(categories, id: \.self) { account in
        Button(action: {
          self.selectedCategory = account
          self.isPresented = false
        }) {
          Text(account.name ?? .empty)
        }
      }
    }
  }
}
