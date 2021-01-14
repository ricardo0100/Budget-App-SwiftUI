//
//  UserSettingsMock.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine
@testable import Beans

class UserSettingsMock: UserSettingsProtocol {
    
    private let userValueSubject = CurrentValueSubject<User?, Never>(nil)
    
    var userPublisher: AnyPublisher<User?, Never> {
        userValueSubject.eraseToAnyPublisher()
    }
    
    var didCallDeleteUser = false
    var didCallSaveUser = false
    var didCallLoadUser = false
    
    func deleteUser() {
        userValueSubject.send(nil)
        didCallDeleteUser = true
    }
    
    init(user: User?) {
        userValueSubject.send(user)
    }
    
    func saveUser(user: User) {
        didCallSaveUser = true
    }
    
    func loadUser() -> User? {
        nil
    }
}
