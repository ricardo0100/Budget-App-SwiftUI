//
//  API.swift
//  Beans
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine

enum APIError: Error {
    case unknown
}

protocol APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError>
}

struct API: APIProtocol {
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Ricardo", email: "ric@rdo.com", token: "1234"))
            .mapError { _ in APIError.unknown }
            .eraseToAnyPublisher()
    }
}

struct APIPreview: APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Ricardo", email: "ric@rdo.com", token: "1234"))
            .mapError { _ in APIError.unknown }
            .eraseToAnyPublisher()
    }
}
