//
//  SignUpView.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 29/05/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var viewModel = SignUpViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        let errorMessage = Text(viewModel.errorMessage ?? .empty)
            .font(.caption)
            .foregroundColor(.red)
        
        return Form {
            Section(footer: errorMessage) {
                TextField("Name", text: $viewModel.name)
                TextField("E-mail", text: $viewModel.email)
                SecureField("Password", text: $viewModel.password)
            }
            Section {
                Button(action: {
                    self.viewModel.signUp()
                }) {
                    Text("Sign Up")
                }
            }
        }.navigationBarTitle("Sign Up")
            .onReceive(viewModel.$dismiss) { shouldDismiss in
                if shouldDismiss {
                    self.presentationMode.wrappedValue.dismiss()
                }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
