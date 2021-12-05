//
//  ProfileView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            if viewModel.email.isEmpty {
                Text("No account")
                    .foregroundColor(.secondary)
            } else {
                Form {
                    Section(header: Text("Name")) {
                        TextField("", text: $viewModel.name)
                            .disabled(!viewModel.isEditing)
                    }
                    Section(header: Text("E-mail")) {
                        TextField("", text: $viewModel.email)
                            .disabled(!viewModel.isEditing)
                    }
                    Button("Logout") {
                        viewModel.onTapLogout()
                    }.foregroundColor(.red)
                }.navigationTitle("Profile")
            }
        }
        .navigationBarItems(
            trailing: Button(viewModel.editButtonText, action: {
                viewModel.isEditing.toggle()
            }))
        .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel(userSession: .preview))
    }
}
