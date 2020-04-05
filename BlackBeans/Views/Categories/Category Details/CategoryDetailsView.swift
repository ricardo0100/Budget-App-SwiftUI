//
//  CategoryDetailsView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct CategoryDetailsView: View {
  
  @State var category: Category
  
  var body: some View {
    Text(category.name ?? .empty)
  }
}
