//
//  API.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Network
import Combine

struct API {

    // MARK: GET Methods
    
    static func getAccounts(updatedAfter timestamp: Date) -> AnyPublisher<[APIAccount], Error> {
        return getResources(updatedAfter: timestamp.timeIntervalSince1970)
    }
    
    static func getCategories(updatedAfter timestamp: Date) -> AnyPublisher<[APICategory], Error> {
        return getResources(updatedAfter: timestamp.timeIntervalSince1970)
    }
    
    static func getBeans(updatedAfter timestamp: Date) -> AnyPublisher<[APIBean], Error> {
        return getResources(updatedAfter: timestamp.timeIntervalSince1970)
    }
    
    static private func getResources<T>(updatedAfter: TimeInterval) -> AnyPublisher<[T], Error> where T: APICodable {
        var urlComponents = URLComponents(url: resourceURL(forType: T.self), resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "updated_after", value: String(updatedAfter))]
        
        guard let url = urlComponents?.url else {
            return Fail(error: APIError.unknown).eraseToAnyPublisher()
        }
        return URLSession.DataTaskPublisher(request: URLRequest(url: url), session: .shared)
            .tryMap { data, response in
                let httpResponse = response as! HTTPURLResponse
                guard (200...299).contains(httpResponse.statusCode) else {
                    let body = String(data: data, encoding: .utf8)
                    throw APIError.server(statusCode: httpResponse.statusCode, url: url, body: body ?? .empty)
                }
                do {
                    let resources = try JSONDecoder().decode([T].self, from: data)
                    Log.info("GET \(url.path)?\(url.query ?? .empty) -> \(resources.count) objects")
                    return resources
                } catch {
                    throw APIError.decoder(error: error as? DecodingError)
                }
        }.eraseToAnyPublisher()
    }
    
    // MARK: POST Methods
    
    static func post(accounts: [Account]) -> AnyPublisher<Void, Error> {
        if accounts.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return accounts
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { account -> AnyPublisher<Void, Error> in
                API.postResource(resource: APIAccount(from: account))
                    .tryMap { apiAccount in
                        account.remoteID = apiAccount.id
                        account.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static func post(categories: [Category]) -> AnyPublisher<Void, Error> {
        if categories.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return categories
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { category -> AnyPublisher<Void, Error> in
                API.postResource(resource: APICategory(from: category))
                    .tryMap { apiAccount in
                        category.remoteID = apiAccount.id
                        category.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static func post(beans: [Bean]) -> AnyPublisher<Void, Error> {
        if beans.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return beans
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { bean -> AnyPublisher<Void, Error> in
                API.postResource(resource: APIBean(from: bean))
                    .tryMap { apiBean in
                        bean.remoteID = apiBean.id
                        bean.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static private func postResource<T>(resource: T) -> AnyPublisher<T, Error> where T: APICodable {
        let url = resourceURL(forType: T.self)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(resource)
        } catch {
            return Fail(error: APIError.encoder(error: error as? EncodingError))
                .eraseToAnyPublisher()
        }
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                let httpResponse = response as! HTTPURLResponse
                guard (200...299).contains(httpResponse.statusCode) else {
                    let body = String(data: data, encoding: .utf8)
                    throw APIError.server(statusCode: httpResponse.statusCode, url: request.url, body: body ?? .empty)
                }
                do {
                    let resource = try JSONDecoder().decode(T.self, from: data)
                    Log.info("POST \(url.path) -> remoteID: \(resource.id)")
                    return resource
                } catch {
                    throw APIError.decoder(error: error as? DecodingError)
                }
        }.eraseToAnyPublisher()
    }
    
    // MARK: PUT Methods
    
    static func put(accounts: [Account]) -> AnyPublisher<Void, Error> {
        if accounts.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return accounts
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { account -> AnyPublisher<Void, Error> in
                API.putResource(resource: APIAccount(from: account))
                    .tryMap { _ in
                        account.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static func put(categories: [Category]) -> AnyPublisher<Void, Error> {
        if categories.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return categories
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { category -> AnyPublisher<Void, Error> in
                API.putResource(resource: APICategory(from: category))
                    .tryMap { _ in
                        category.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static func put(beans: [Bean]) -> AnyPublisher<Void, Error> {
        if beans.isEmpty {
            return Just(())
                .mapError { _ in APIError.unknown }
                .eraseToAnyPublisher()
        }
        return beans
            .publisher
            .mapError { _ in APIError.unknown }
            .flatMap { bean -> AnyPublisher<Void, Error> in
                API.putResource(resource: APIBean(from: bean))
                    .tryMap { _ in
                        bean.shouldSync = false
                        try Persistency.shared.context.save()
                }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    static private func putResource<T>(resource: T) -> AnyPublisher<T, Error> where T: APICodable {
        var url = resourceURL(forType: T.self)
        url.appendPathComponent(String(resource.id))
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody = try JSONEncoder().encode(resource)
        } catch {
            return Fail(error: APIError.encoder(error: error as? EncodingError))
                .eraseToAnyPublisher()
        }
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                let httpResponse = response as! HTTPURLResponse
                guard (200...299).contains(httpResponse.statusCode) else {
                    let body = String(data: data, encoding: .utf8)
                    throw APIError.server(statusCode: httpResponse.statusCode, url: url, body: body ?? .empty)
                }
                do {
                    let resource = try JSONDecoder().decode(T.self, from: data)
                    Log.info("PUT \(url.path) -> remoteID: \(resource.id)")
                    return resource
                } catch {
                    throw APIError.decoder(error: error as? DecodingError)
                }
        }.eraseToAnyPublisher()
    }
    
    // MARK: Authentication
    
    static func login(email: String, password: String) -> AnyPublisher<User, Error> {
        var request = URLRequest(url: loginURL())
        request.httpMethod = "POST"
        let str = getPostString(params: ["email": email, "password": password])
        request.httpBody = str.data(using: .utf8)
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, _ in
                return try JSONDecoder().decode(User.self, from: data)
        }.eraseToAnyPublisher()
    }
    
    static func signUp(name: String, email: String, password: String) -> AnyPublisher<User, APIError> {
        var request = URLRequest(url: signUpURL())
        request.httpMethod = "POST"
        let str = getPostString(params: ["name": name,
                                         "email": email,
                                         "password": password])
        request.httpBody = str.data(using: .utf8)
        return URLSession.DataTaskPublisher(request: request, session: .shared)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                if response.statusCode == 409 {
                    let serverMessage = String(data: data, encoding: .utf8)
                    throw APIError.server(statusCode: response.statusCode,
                                          url: request.url,
                                          body: serverMessage ?? .empty)
                }
                return data
        }
        .decode(type: User.self, decoder: JSONDecoder())
        .mapError { error in
            if let error = error as? DecodingError {
                return APIError.decoder(error: error)
            }
            if let error = error as? URLError {
                return APIError.url(error: error)
            }
            return error as? APIError ?? .unknown
        }.eraseToAnyPublisher()
    }
    
    // MARK: URLs
    
    static private func baseURL() -> URL {
        guard let string = ProcessInfo.processInfo.environment["API_URL"],
            let url = URL(string: string) else {
                Log.error("Error creating API URL")
                fatalError()
        }
        return url
    }
    
    static private func loginURL() -> URL {
        var url = baseURL()
        url.appendPathComponent("login")
        return url
    }
    
    static private func signUpURL() -> URL {
        var url = baseURL()
        url.appendPathComponent("signup")
        return url
    }
    
    static private func resourceURL(forType type: APICodable.Type) -> URL {
        var url = baseURL()
        switch type {
        case is APIAccount.Type:
            url.appendPathComponent("account")
        case is APICategory.Type:
            url.appendPathComponent("category")
        case is APIBean.Type:
            url.appendPathComponent("bean")
        default:
            break
        }
        return url
    }
    
    private static func getPostString(params: [String: Any]) -> String {
        var data = [String]()
        for(key, value) in params { data.append("\(key)=\(value)") }
        return data.map { String($0) }.joined(separator: "&")
    }
}
