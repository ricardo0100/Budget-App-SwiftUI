//
//  SignUpViewModel.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 29/05/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject, Identifiable {
    
    @Published var name: String = .empty
    @Published var email: String = .empty
    @Published var password: String = .empty
    
    @Published var errorMessage: String? = .empty
    
    @Published var dismiss = false
    
    private var cancellables: [AnyCancellable] = []
    
    
    func signUp() {
        errorMessage = .empty
        
        //TODO: Validate all fields correctly
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Fill all fields"
            return
        }
        
        API.signUp(name: name, email: email, password: password)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    OperationQueue.main.addOperation {
                        self.errorMessage = error.userMessage
                    }
                case .finished:
                    break
                }
            }) { user in
                OperationQueue.main.addOperation {
                    Persistency.currentUser = user
                    self.dismiss.toggle()
                }
        }.store(in: &cancellables)
    }
    
}
