//
//  UserController.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import Foundation
import Security
import Combine

class UserSettings: ObservableObject {
    
    private let userValueSubject = CurrentValueSubject<User?, Never>(nil)
    
    var userPublisher: AnyPublisher<User?, Never> {
        userValueSubject.eraseToAnyPublisher()
    }
    
    func saveUser(user: User) {
        userValueSubject.send(user)
    }
    
    func loadUser() -> User? {
        return nil
    }
    
    func deleteUser() {
        userValueSubject.send(nil)
    }
}
