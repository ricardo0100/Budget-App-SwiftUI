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
                Section {
                    FormTextField(fieldName: "Name",
                                  text: $viewModel.name,
                                  error: $viewModel.nameError)
                    FormTextField(fieldName: "E-mail",
                                  keyboardType: .emailAddress,
                                  text: $viewModel.email,
                                  error: $viewModel.emailError)
                    FormTextField(fieldName: "Password",
                                  useSecureField: true,
                                  text: $viewModel.password,
                                  error: $viewModel.passwordError)
                } header: {
                    Text("Sign Up")
                } footer: {
                    HStack {
                        Spacer()
                        Button("Sign Up") {
                            viewModel.onTapSignUp()
                        }.buttonStyle(.borderedProminent)
                            .font(.callout)
                    }
                }
                
                Section {
                    NavigationLink("Login", destination: LogInView())
                } header: {
                    Text("Already have an account?")
                }
            }
            .navigationTitle("Welcome")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Skip") {
                        viewModel.onTapSkip()
                    }
                }
            }
        }
        .alert(item: $viewModel.alert) { alert -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: nil)
        }
        .onAppear(perform: {
            #if DEBUG
            viewModel.name = "Ricardo Gehrke"
            viewModel.email = "ricardo0100@gmail.com"
            viewModel.password = "123456"
            #endif
        })
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SignUpView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            SignUpView(viewModel: SignUpViewModel(urlSession: .shared, userSession: .preview))
            SignUpView(viewModel: SignUpViewModel(urlSession: .shared, userSession: .preview))
                .preferredColorScheme(.dark)
        }
    }
}
