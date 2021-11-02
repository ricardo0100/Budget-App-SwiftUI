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
            VStack {
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
                
                Button("Sign up") {
                    viewModel.onTapSignUp()
                }.buttonStyle(.borderedProminent)
                
                Spacer()
                Text("Already have an account?")
                
                NavigationLink(
                    destination: LogInView(),
                    label: {
                        HStack {
                            Spacer()
                            Text("Log In")
                            Spacer()
                        }
                    })
                
                Spacer()
                Button("Skip") {
                    viewModel.onTapSkip()
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
        Group {
            SignUpView(viewModel: SignUpViewModel(urlSession: .shared, userSession: .preview))
            SignUpView(viewModel: SignUpViewModel(urlSession: .shared, userSession: .preview))
                .previewDevice("iPhone 8")
                .preferredColorScheme(.dark)
        }
    }
}
