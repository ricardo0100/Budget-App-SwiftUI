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
    
    @Published var user: User?
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        user = Self.loadUser(from: userDefaults)
    }
    
    func saveUser(user: User) {
        let data = try? JSONEncoder().encode(user)
        userDefaults.set(data, forKey: "user")
        self.user = user
    }
    
    func deleteUser() {
        userDefaults.removeObject(forKey: "user")
        user = nil
    }
    
    private static func loadUser(from userDefaults: UserDefaults) -> User? {
        guard let data = userDefaults.value(forKey: "user") as? Data else { return nil }
        let user = try? JSONDecoder().decode(User.self, from: data)
        return user
    }
}
