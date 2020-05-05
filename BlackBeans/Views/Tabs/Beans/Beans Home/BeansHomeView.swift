//
//  BeansHomeView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeansHomeView: View {
  
  @State private var isEditingBeanPresented: Bool = false
  @State private var isBeanDetailsPresented: Bool = false
  
  var body: some View {
    let editButton = Button(action: {
      self.isEditingBeanPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    return NavigationView {
      VStack(spacing: 0) {
        BeansListView(type: .all)
        Rectangle()
          .frame(height: 1)
          .foregroundColor(Color.gray.opacity(0.5))
        BeansSumView(type: .all)
          .background(Color.gray.opacity(0.1))
      }
      .navigationBarTitle("Transactions")
      .navigationBarItems(trailing: editButton)
    }
    .sheet(isPresented: self.$isEditingBeanPresented) { () -> EditBeanView in
      EditBeanView(editBeanViewModel: EditBeanViewModel(), isPresented: self.$isEditingBeanPresented)
    }.tabItem {
        Image(systemName: "cart")
        Text("Beans")
    }
  }
}
