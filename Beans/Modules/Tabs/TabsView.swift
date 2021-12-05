//
//  TabsView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import SwiftUI

struct TabsView: View {
    
    @ObservedObject var viewModel = TabsViewModel()
    
    var body: some View {
        TabView {
            // Items
            NavigationView {
                RecentItemsView()
            }.tabItem {
                VStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    Text("Items")
                }
            }
            
            // Accounts
            NavigationView {
                AccountsListView()
            }.tabItem {
                VStack {
                    Image(systemName: "creditcard")
                    Text("Accounts")
                }
            }
            
            // Categories
            NavigationView {
                CategoryList()
            }.tabItem {
                VStack {
                    Image(systemName: "tray.full")
                    Text("Categories")
                }
            }
            
            // Profile
            NavigationView {
                ProfileView()
            }.tabItem {
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
