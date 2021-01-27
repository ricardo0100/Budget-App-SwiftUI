//
//  SignUpView.swift
//  Beans
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel = SignUpViewModel()
    
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
                Section(header: Text("Already have an account?")) {
                    NavigationLink(
                        destination: LogInView(),
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
        .alert(item: $viewModel.alert) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: nil)
        }
        .onAppear(perform: {
            viewModel.name = "Ricardo Gehrke"
            viewModel.email = "ricardo0100@gmail.com"
            viewModel.password = "123456"
        })
    }
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        SignUpView(viewModel: SignUpViewModel(api: APIPreview(), userSession: .preview))
    }
}
