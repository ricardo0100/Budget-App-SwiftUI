//
//  LoginViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 28/05/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine
import CryptoKit

class LoginViewModel: ObservableObject, Identifiable {
    
    @Published var email: String = .empty
    @Published var password: String = .empty
    @Published var errorMessage: String?
    var cancellables: [AnyCancellable] = []
    
    func login() {
        if email.isEmpty {
            errorMessage = "Email is required"
            return
        }
        if password.isEmpty {
            errorMessage = "Password is required"
            return
        }
        errorMessage = nil
        API.login(email: email, password: password)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }) { user in
                Persistency.currentUser = user
        }.store(in: &cancellables)
    }
}
