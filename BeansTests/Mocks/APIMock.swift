//
//  APIMock.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine
@testable import Beans

class APIMock: APIProtocol {
    
    var didCallLogin = false
    private let user: User?
    private let mockError: APIError?
    
    init(mockUser: User? = nil, mockError: APIError? = nil) {
        self.user = mockUser
        self.mockError = mockError
    }
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        didCallLogin = true
        if let user = user {
            return Just(user)
                .mapError { _ in APIError.wrongCredentials }
                .eraseToAnyPublisher()
        } else if let error = mockError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.wrongCredentials)
            .eraseToAnyPublisher()
    }
}
