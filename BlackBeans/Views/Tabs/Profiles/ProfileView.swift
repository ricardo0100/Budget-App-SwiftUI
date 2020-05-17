//
//  ProfileView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 27/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  
  @State var timestampString = Synchronizer.lastSyncPublisher.value
  
  var body: some View {
    VStack {
      Button(action: {
        Synchronizer.synchronize()
      }) {
        Text("Start Synchronization")
      }
      Text(timestampString.fullDateAndTimeString)
    }.tabItem {
      Image(systemName: "person")
      Text("Profile")
    }.onReceive(Synchronizer.lastSyncPublisher) {
      self.timestampString = $0
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView()
  }
}
