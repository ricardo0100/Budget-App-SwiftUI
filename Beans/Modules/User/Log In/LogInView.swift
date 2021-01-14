//
//  LogInView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 11/01/21.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var viewModel: LogInViewModel
    
    var body: some View {
        Form {
            Section(header: Text("E-mail")) {
                FormTextField(placeholder: "",
                              text: $viewModel.email,
                              error: $viewModel.emailError)
            }
            Section(header: Text("Password")) {
                FormTextField(placeholder: "",
                              text: $viewModel.password,
                              error: $viewModel.passwordError)
            }
            Section {
                HStack {
                    Spacer()
                    Button("Log In") {
                        viewModel.onTapLogIn()
                    }
                    Spacer()
                }
                .listRowBackground(Color.accentColor)
                .foregroundColor(.white)
            }
        }.navigationTitle("Log In")
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView(viewModel: LogInViewModel(userSettings: UserSettingsPreview()))
        }
    }
}
