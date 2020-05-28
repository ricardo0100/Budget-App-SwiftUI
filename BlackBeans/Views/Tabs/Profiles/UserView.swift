//
//  UserView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 27/05/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct UserView: View {
    
    @State var timestampString = Synchronizer.lastSyncPublisher.value
    
    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                Text(Persistency.currentUser?.name ?? .empty)
                Text(Persistency.currentUser?.email ?? .empty)
            }
            Section(header: Text("Synchronization")) {
                Text(timestampString.fullDateAndTimeString)
                Button(action: {
                    Synchronizer.synchronize()
                }) {
                    Text("Start Synchronization")
                }
            }
            Section {
                Button(action: {
                    Persistency.currentUser = nil
                }) {
                    Text("Logout").foregroundColor(Color.red)
                }
            }
        }.onReceive(Synchronizer.lastSyncPublisher) {
            self.timestampString = $0
        }.navigationBarTitle("Profile")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
