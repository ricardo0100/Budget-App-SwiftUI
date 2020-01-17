//
//  ContentView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import CoreData

struct MainView: View {
  
  @FetchRequest(fetchRequest: Bean.allBeansFetchRequest()) var beans: FetchedResults<Bean>
  @State private var showAddBeanView: Bool = false
  
  var body: some View {
    NavigationView {
      List {
        ForEach(beans, id: \.self) { bean in
          HStack {
            Text(bean.name ?? "")
            Text("\(bean.value)")
          }
        }
      }
      .sheet(isPresented: self.$showAddBeanView) {
        AddBeanView()
      }
      .navigationBarTitle("All Beans")
      .navigationBarItems(trailing: Button(action: {
        self.showAddBeanView = true
      }) {
        Image(systemName: "plus")
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
