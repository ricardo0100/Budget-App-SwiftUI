//
//  UserManager.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import Foundation
import Security
import Combine

protocol UserManagerProtocol {
    var userPublisher: AnyPublisher<User?, Never> { get }
    func logout()
}

class UserManager: UserManagerProtocol {
    
    static let shared = UserManager()
    
    var userPublisher: AnyPublisher<User?, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    init() {
        userSubject.send(loadUser())
    }
    
    func logout() {
        userSubject.send(nil)
    }
    
    private let userSubject = CurrentValueSubject<User?, Never>(nil)
    
    private func loadUser() -> User? {
//        let key = "user"
//        let tag = "com.beans.keys.user".data(using: .utf8)!
//        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
//                                       kSecAttrApplicationTag as String: tag,
//                                       kSecValueRef as String: key]
        return User(name: "Ricardo Gehrke", email: "ricardo@beans.com", token: "absjkbdhjbhjsbdhj")
    }
}

class UserManagerMock: UserManagerProtocol {
    
    var userPublisher: AnyPublisher<User?, Never> {
        userSubject.eraseToAnyPublisher()
    }
    
    private let userSubject: CurrentValueSubject<User?, Never>
    
    init(name: String = "Ricardo Gehrke", email: String = "ricardo@beans.com", token: String =  "1234") {
        let user = User(name: name, email: email, token: token)
        userSubject = CurrentValueSubject<User?, Never>(user)
    }
    
    func logout() {
        userSubject.send(nil)
    }
}
