//
//  API.swift
//  Beans
//
//  Created by Ricardo Gehrke on 12/01/21.
//

import Foundation
import Combine

enum APIError: Error {
    case wrongCredentials
    case noConnection
    case serverError
}

protocol APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError>
}

struct API: APIProtocol {
    
    private let baseURLString = "http://127.0.0.1:5000"
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        guard let url = URL(string: baseURLString + "/login") else {
            return Fail(error: APIError.serverError)
                .eraseToAnyPublisher()
        }
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "email", value: email),
                                    URLQueryItem(name: "password", value: password)]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                let httpResponse = element.response as? HTTPURLResponse
                switch httpResponse?.statusCode {
                case 200:
                    return element.data
                case 401:
                    throw APIError.wrongCredentials
                default:
                    throw APIError.serverError
                }
            }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { print($0); return $0 as? APIError ?? .serverError }
            .eraseToAnyPublisher()
    }
}

struct APIPreview: APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Ricardo", email: "ric@rdo.com", token: "1234"))
            .mapError { _ in APIError.wrongCredentials }
            .eraseToAnyPublisher()
    }
}
