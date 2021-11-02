//
//  SignUpViewModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import Foundation
import Combine

class SignUpViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var passwordError: String?
    
    @Published var alert: AlertMessage?
    @Published var isInProgress: Bool = false
    
    private let userSession: UserSession
    private let api: API
    private var cancellables: [AnyCancellable] = []
    
    init(urlSession: URLSession = .shared, userSession: UserSession = .shared) {
        self.api = API(urlSession: urlSession)
        self.userSession = userSession
    }
    
    func onTapSignUp() {
        validateNameField()
        validateEmailField()
        validatePasswordField()
        
        guard nameError == nil,
              passwordError == nil,
              emailError == nil else { return }
        
        executeLoginRequest()
    }
    
    func onTapSkip() {
        self.userSession.saveUser(user: User(name: "", email: "", token: ""))
    }
    
    private func executeLoginRequest() {
        isInProgress = true
        api
            .signUp(name: name, email: email, password: password)
            .receive(on: OperationQueue.main)
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
    
    private func handleError(_ error: APIError) {
        switch error {
        case .wrongCredentials:
            self.alert = AlertMessage(title: "Sign Up failed!", message: "The information provided is incorrect.")
        case .serverError:
            self.alert = AlertMessage(title: "Server error!", message: "Something is wrong with the server, please try again later.")
        case .badURL:
            fatalError("Bad URL error")
        }
    }
    
    private func validateNameField() {
        nameError = nil
        if name.isEmpty {
            nameError = "Name field should not be empty"
        }
    }
    
    private func validateEmailField() {
        emailError = nil
        if email.isEmpty {
            emailError = "E-mail field should not be empty"
            return
        }
        if !isValidEmail(email) {
            emailError = "Inform a valid e-mail"
        }
    }
    
    private func validatePasswordField() {
        passwordError = nil
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
}
