//
//  HomeView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    TabView {
      BeansHomeView()
        .environment(\.managedObjectContext, Persistency.shared.context)
        .tabItem {
          Image(systemName: "cart")
          Text("Beans")
      }
      AccountsListView()
        .environment(\.managedObjectContext, Persistency.shared.context)
        .tabItem {
          Image(systemName: "creditcard")
          Text("Accounts")
      }
      CategoriesList()
        .environment(\.managedObjectContext, Persistency.shared.context)
        .tabItem {
          Image(systemName: "tray.full")
          Text("Categories")
      }
    }
  }
}
