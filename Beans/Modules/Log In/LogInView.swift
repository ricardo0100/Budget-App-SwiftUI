//
//  LogInView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 11/01/21.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var viewModel = LogInViewModel()
    
    var body: some View {
        Form {
            Section(header: Text("E-mail")) {
                FormTextField(keyboardType: .emailAddress,
                              placeholder: "",
                              text: $viewModel.email,
                              error: $viewModel.emailError,
                              useSecureField: false)
            }
            Section(header: Text("Password")) {
                FormTextField(keyboardType: .default,
                              placeholder: "",
                              text: $viewModel.password,
                              error: $viewModel.passwordError,
                              useSecureField: true)
            }
            Section {
                FormButton(action: viewModel.onTapLogIn, text: "Log in",
                           disabled: $viewModel.isInProgress,
                           showProgressView: $viewModel.isInProgress)
            }
        }
        .navigationTitle("Log In")
        .alert(item: $viewModel.alert) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: nil)
        }
        .onAppear(perform: {
            viewModel.email = "ricardo0100@gmail.com"
            viewModel.password = "123456"
        })
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView(viewModel: LogInViewModel(urlSession: .shared, userSession: .preview))
        }
    }
}
