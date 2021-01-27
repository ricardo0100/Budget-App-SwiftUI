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
    case badURL
}

protocol APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError>
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, APIError>
}

class API: ObservableObject, APIProtocol {
    
    private let baseURLString = "http://127.0.0.1:5000"
    
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        let query = [URLQueryItem(name: "email", value: email),
                     URLQueryItem(name: "password", value: password)]
        guard let request = createURLRequest(path: "/login", queryItems: query, method: "POST") else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap() { try self.getData(from: $0) }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { $0 as? APIError ?? .serverError }
            .delay(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, APIError> {
        let query = [URLQueryItem(name: "name", value: name),
                     URLQueryItem(name: "email", value: email),
                     URLQueryItem(name: "password", value: password)]
        guard let request = createURLRequest(path: "/signup", queryItems: query, method: "POST") else {
            return Fail(error: APIError.badURL).eraseToAnyPublisher()
        }
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap() { try self.getData(from: $0) }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { $0 as? APIError ?? .serverError }
            .eraseToAnyPublisher()
    }
    
    private func createURLRequest(path: String, queryItems: [URLQueryItem], method: String = "GET") -> URLRequest? {
        guard let url = URL(string: baseURLString + path) else { return nil }
        var urlComponents = URLComponents()
        urlComponents.queryItems = queryItems
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = urlComponents.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private func getData(from response: URLSession.DataTaskPublisher.Output) throws -> Data {
        let httpResponse = response.response as? HTTPURLResponse
        switch httpResponse?.statusCode {
        case 200:
            return response.data
        case 401, 404:
            throw APIError.wrongCredentials
        default:
            throw APIError.serverError
        }
    }
}

class APIPreview: ObservableObject, APIProtocol {
    func login(email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Ricardo", email: "ric@rdo.com", token: "1234"))
            .mapError { _ in APIError.wrongCredentials }
            .eraseToAnyPublisher()
    }
    
    func signUp(name: String, email: String, password: String) -> AnyPublisher<User, APIError> {
        Just(User(name: "Ricardo", email: "ric@rdo.com", token: "1234"))
            .mapError { _ in APIError.wrongCredentials }
            .eraseToAnyPublisher()
    }
}
