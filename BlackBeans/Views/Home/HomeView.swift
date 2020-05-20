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
  
  @State private var notificationText: String?
  
  private func notificationView() -> some View {
    return Text(self.notificationText ?? .empty)
      .font(.footnote)
      .padding(6)
      .foregroundColor(Color.white)
      .background(Color(.darkText).opacity(0.8))
      .cornerRadius(4)
      .zIndex(1)
      .animation(.spring())
      .offset(y: 8)
      .onReceive(Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()) { _ in
        withAnimation {
          self.notificationText = nil
        }
    }
  }
  
  private func handle(_ syncStatus: Synchronizer.SyncStatus) {
    withAnimation {
      switch syncStatus {
      case .running:
        self.notificationText = "Synchronizing"
      case .completed:
        self.notificationText = "Synchronization complete!"
      default:
        break
      }
    }
  }
  
  var body: some View {
    ZStack(alignment: .top) {
      if self.notificationText != nil {
        notificationView()
      }
      TabView {
        BeansHomeView()
        AccountsListView()
        CategoriesListView()
        ProfileView()
      }
    }.onReceive(Synchronizer.status.receive(on: OperationQueue.main)) { syncStatus in
      self.handle(syncStatus)
    }
  }
}
