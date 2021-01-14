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
    
    private let userSettings: UserSettingsProtocol
    
    init(userSettings: UserSettingsProtocol) {
        self.userSettings = userSettings
    }
    
    func onTapLogIn() {
        validateEmailField()
        validatePasswordField()
        
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
