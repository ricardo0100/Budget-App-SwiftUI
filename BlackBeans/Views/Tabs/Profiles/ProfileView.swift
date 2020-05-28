//
//  ProfileView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 27/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @State var currentUser: User?
    
    var body: some View {
        NavigationView {
            if currentUser == nil {
                LoginView()
            } else {
                UserView()
            }
        }.onReceive(Persistency.currentUserPublisher, perform: {
            print($0)
            self.currentUser = $0
        }).tabItem {
            Image(systemName: "person")
            Text("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
