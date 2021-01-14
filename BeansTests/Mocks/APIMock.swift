//
//  APIMock.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine
@testable import Beans

struct APIMock: APIProtocol {
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Test", email: "test@test.com", token: ""))
            .mapError { _ in APIError.unknown }
            .eraseToAnyPublisher()
    }
}
