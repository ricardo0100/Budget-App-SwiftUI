//
//  UserSession.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import Foundation
import Combine

class UserSession {
    
    static let shared: UserSession = .init()
    
    static let preview: UserSession = {
        let userSession = UserSession(userDefaults: UserDefaults(suiteName: #filePath)!)
        userSession.createPreviewUser()
        return userSession
    }()
    
    lazy var userPublisher: AnyPublisher<User?, Never> = {
        currentUser.eraseToAnyPublisher()
    }()
    
    var user: User? {
        currentUser.value
    }
    
    private let userDefaults: UserDefaults
    private let currentUser: CurrentValueSubject<User?, Never>
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        currentUser = .init(Self.loadUser(from: userDefaults))
    }
    
    func saveUser(user: User) {
        let data = try? JSONEncoder().encode(user)
        userDefaults.set(data, forKey: "user")
        self.currentUser.send(user)
    }
    
    func deleteUser() {
        userDefaults.removeObject(forKey: "user")
        currentUser.send(nil)
    }
    
    private static func loadUser(from userDefaults: UserDefaults) -> User? {
        guard let data = userDefaults.value(forKey: "user") as? Data else { return nil }
        let user = try? JSONDecoder().decode(User.self, from: data)
        return user
    }
}

extension UserSession {
    
    func createPreviewUser() {
        saveUser(user: User(name: "Ricardo Gehrke Filho", email: "ricardo@gehrke.filho", token: "1234"))
    }
}
