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
            Section {
                FormTextField(fieldName: "E-mail",
                              placeholder: "",
                              keyboardType: .emailAddress,
                              text: $viewModel.email,
                              error: $viewModel.emailError)
                FormTextField(fieldName: "Password",
                              placeholder: "",
                              useSecureField: true,
                              text: $viewModel.password,
                              error: $viewModel.passwordError)
            } footer: {
                HStack {
                    Spacer()
                    Button("Log In", action: viewModel.onTapLogIn)
                        .buttonStyle(.borderedProminent)
                        .font(.callout)
                }
            }
        }
        .navigationTitle("Log In")
        .alert(item: $viewModel.alert) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: nil)
        }
        .onAppear(perform: {
            #if DEBUG
            viewModel.email = "ricardo0100@gmail.com"
            viewModel.password = "123456"
            #endif
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
