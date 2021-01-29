//
//  APIMock.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine
@testable import Beans

// TODO: Improve the way this class is created and configured. Maybe "Builder" Design Pattern
class APIMock: APIProtocol {
    
    private let user: User?
    private let mockError: APIError?
    var didCallLogin = false
    var didCallSignUp = false
    var didCallGetAccounts = false
    
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
    
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, APIError> {
        didCallSignUp = true
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
    
    func getAccounts(after timestamp: Date) -> AnyPublisher<[Account], APIError> {
        didCallGetAccounts = true
        return Just([])
            .mapError { _ in APIError .wrongCredentials }
            .eraseToAnyPublisher()
    }
}
