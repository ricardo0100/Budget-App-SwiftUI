//
//  HomeView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 03/03/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI
import Combine

struct HomeView: View {
  
  @State private var toastText: String?
  
  var body: some View {
    ZStack(alignment: .top) {
      if self.toastText != nil {
        Text(self.toastText ?? .empty)
          .padding()
          .foregroundColor(Color.white)
          .background(Color(.darkText).opacity(0.8))
          .cornerRadius(16)
          .zIndex(1)
          .animation(.spring())
          .onReceive(Timer.publish(every: 2, on: .main, in: .common).autoconnect()) { _ in
            withAnimation {
              self.toastText = nil
            }
          }
      }
      
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
        Button(action: {
          Synchronizer.synchronize()
        }) {
          Text("Start Synchronization")
        }.tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
      }
    }.onReceive(Synchronizer.status) { syncStatus in
      withAnimation {
        switch syncStatus {
        case .running:
          self.toastText = "Sync ON"
        case .completed:
          self.toastText = "Sync DONE"
        default:
          break
        }
      }
    }
  }
}
