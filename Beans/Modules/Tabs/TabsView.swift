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
            RecentItemsView().tabItem {
                VStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    Text("Items")
                }
            }
            AccountsListView().tabItem {
                VStack {
                    Image(systemName: "creditcard")
                    Text("Accounts")
                }
            }
            ProfileView().tabItem {
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
