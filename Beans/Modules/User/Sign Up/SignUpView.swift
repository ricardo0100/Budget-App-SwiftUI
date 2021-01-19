//
//  SignUpView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var userSettings: UserSettings
    
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    FormTextField(keyboardType: .default,
                                  placeholder: "",
                                  text: $viewModel.name,
                                  error: $viewModel.nameError,
                                  useSecureField: false)
                }
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
                    HStack {
                        Spacer()
                        Button("Sign Up") {
                            viewModel.onTapSignUp()
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.accentColor)
                    .foregroundColor(.white)
                }
                Section(header: Text("New user?")) {
                    NavigationLink(
                        destination: LogInView(viewModel: LogInViewModel(api: API(), userSettings: userSettings)),
                        label: {
                            HStack {
                                Spacer()
                                Text("Log In")
                                Spacer()
                            }
                        })
                }
            }.navigationTitle("Welcome")
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel(userSettings: UserSettings()))
    }
}
