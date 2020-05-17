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

enum APIError: Error {
  case noInternet
  case server(statusCode: Int, url: URL?, body: String)
  case encoder(type: Any, error: EncodingError?)
  case decoder(type: Any, error: DecodingError?)
  case unknown
  
  var localizedDescription: String {
    switch self {
    case .noInternet:
      return "Internet unavailable"
    case .server(let statusCode, let url, _):
      return "Server error code \(statusCode) in \(url?.absoluteString ?? .empty)"
    case .encoder(let type, _):
      return "Error encoding \(String(describing: type.self))"
    case .decoder(let type, _):
      return "Error decoding \(String(describing: type.self))"
    case .unknown:
      return "Unknown API Error"
    }
  }
}

protocol APICodable: Codable {
  var id: Int64 { get }
}

struct API {
  
  static func resourceURL(forType type: APICodable.Type) -> URL {
    guard let string = ProcessInfo.processInfo.environment["API_URL"],
      var url = URL(string: string) else {
        Log.error("Error creating API URL")
        fatalError()
    }
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
  
  static func getAccounts(updatedAfter timestamp: Date) -> AnyPublisher<[APIAccount], Error> {
    return getResources(updatedAfter: timestamp.timeIntervalSince1970)
  }
  
  static func getCategories(updatedAfter timestamp: Date) -> AnyPublisher<[APICategory], Error> {
    return getResources(updatedAfter: timestamp.timeIntervalSince1970)
  }
  
  static func getBeans(updatedAfter timestamp: Date) -> AnyPublisher<[APIBean], Error> {
    return getResources(updatedAfter: timestamp.timeIntervalSince1970)
  }
  
  static func postAccounts(accounts: [Account]) -> AnyPublisher<Void, Error> {
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
  
  static func putAccounts(accounts: [Account]) -> AnyPublisher<Void, Error> {
    if accounts.isEmpty {
      return Just(()).mapError { _ in APIError.unknown }.eraseToAnyPublisher()
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
          return try JSONDecoder().decode([T].self, from: data)
        } catch {
          throw APIError.decoder(type: T.self, error: error as? DecodingError)
        }
    }.eraseToAnyPublisher()
  }
  
  static private func postResource<T>(resource: T) -> AnyPublisher<T, Error> where T: APICodable {
    var request = URLRequest(url: resourceURL(forType: T.self))
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    do {
      request.httpBody = try JSONEncoder().encode(resource)
    } catch {
      return Fail(error: APIError.encoder(type: T.self, error: error as? EncodingError))
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
          return try JSONDecoder().decode(T.self, from: data)
        } catch {
          throw APIError.decoder(type: T.self, error: error as? DecodingError)
      }
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
      return Fail(error: APIError.encoder(type: T.self, error: error as? EncodingError))
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
          return try JSONDecoder().decode(T.self, from: data)
        } catch {
          throw APIError.decoder(type: T.self, error: error as? DecodingError)
      }
    }.eraseToAnyPublisher()
  }
}
