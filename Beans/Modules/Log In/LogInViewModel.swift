//
//  LogInViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 11/01/21.
//

import Foundation
import Combine

class LogInViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var emailError: String?
    @Published var passwordError: String?
    
    @Published var alert: AlertMessage?
    @Published var isInProgress: Bool = false
    
    private let api: APIProtocol
    private let userSession: UserSession
    private var cancellables: [AnyCancellable] = []
    
    init(urlSession: URLSession = .shared, userSession: UserSession = .shared) {
        self.api = API(urlSession: urlSession)
        self.userSession = userSession
    }
    
    func onTapLogIn() {
        clearErrors()
        validateEmailField()
        validatePasswordField()
        
        if emailError == nil && passwordError == nil {
            isInProgress = true
            api
                .login(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.handleError(error)
                    case .finished:
                        break
                    }
                    self.isInProgress = false
                } receiveValue: { user in
                    self.userSession.saveUser(user: user)
                }.store(in: &cancellables)
        }
    }
    
    private func validateEmailField() {
        if email.isEmpty {
            emailError = "E-mail field should not be empty"
            return
        }
        if !isValidEmail(email) {
            emailError = "Inform a valid e-mail"
        }
    }
    
    private func validatePasswordField() {
        if password.isEmpty {
            passwordError = "Password field should not be empty"
            return
        }
        if password.count < 6 {
            passwordError = "Password should cointain at least 6 characters"
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func clearErrors() {
        emailError = nil
        passwordError = nil
    }
    
    private func handleError(_ error: APIError) {
        switch error {
        case .wrongCredentials:
            self.alert = AlertMessage(title: "Login failed!", message: "The credentials provided are incorrect.")
        case .serverError:
            self.alert = AlertMessage(title: "Server error!", message: "Something is wrong with the server, please try again later.")
        case .badURL:
            fatalError("Bad URL error")
        }
    }
}
