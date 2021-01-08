//
//  TabsView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import SwiftUI

struct TabsView: View {
    
    var body: some View {
        TabView {
            NavigationView {
                AccountsListView()
            }.tabItem {
                VStack {
                    Image(systemName: "creditcard")
                    Text("Accounts")
                }
            }
            RecentItemsView().tabItem {
                VStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    Text("Items")
                }
            }
            ProfileView(viewModel: ProfileViewModel()).tabItem {
                VStack {
                    Image(systemName: "person")
                    Text("Profile")
                }
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
