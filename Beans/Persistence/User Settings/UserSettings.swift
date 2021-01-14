//
//  UserController.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import Foundation
import Security
import Combine

protocol UserSettingsProtocol {
    var userPublisher: AnyPublisher<User?, Never> { get }
    func saveUser(user: User)
    func loadUser() -> User?
    func deleteUser()
}

class UserSettings: ObservableObject, UserSettingsProtocol {
    
    private let userValueSubject = CurrentValueSubject<User?, Never>(nil)
    
    var userPublisher: AnyPublisher<User?, Never> {
        userValueSubject.eraseToAnyPublisher()
    }
    
    func saveUser(user: User) {
        
    }
    
    func loadUser() -> User? {
        return nil
    }
    
    func deleteUser() {
        
    }
}

class UserSettingsPreview: UserSettingsProtocol {
    
    var userPublisher: AnyPublisher<User?, Never> = Just(User(name: "Ricardo",
                                                              email: "ric@rdo.com",
                                                              token: "1234")).eraseToAnyPublisher()
    func saveUser(user: User) { }
    
    func loadUser() -> User? { nil }
    
    func deleteUser() { }
}
