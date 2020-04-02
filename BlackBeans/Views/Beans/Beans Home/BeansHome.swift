//
//  BeansHome.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 02/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct BeansHome: View {
  
  @State private var isEditingBeanPresented: Bool = false
  @State private var isBeanDetailsPresented: Bool = false
  
  var body: some View {
    let sum = HStack {
      Text("Total")
      Spacer()
      Text(Persistency.shared.allBeansSum.toCurrency ?? .empty)
        .foregroundColor(Persistency.shared.allBeansSum > 0 ? Color.green : Color.red)
    }.padding()
    
    let editButton = Button(action: {
      self.isEditingBeanPresented = true
    }) {
      Image(systemName: "plus")
    }
    
    return NavigationView {
      VStack {
        BeansListView(type: .all)
        Spacer()
        sum
      }
      .navigationBarTitle("Transactions")
      .navigationBarItems(trailing: editButton)
    }
    .sheet(isPresented: self.$isEditingBeanPresented) { () -> EditBeanView in
      EditBeanView(editBeanViewModel: EditBeanViewModel(), isPresented: self.$isEditingBeanPresented)
    }
  }
}
