//
//  ProfileView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 27/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
  var body: some View {
    Button(action: {
      Synchronizer.synchronize()
    }) {
      Text("Start Synchronization")
    }.tabItem {
      Image(systemName: "person")
      Text("Profile")
    }
  }
}
