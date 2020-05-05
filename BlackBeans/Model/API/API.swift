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
  case request(statusCode: Int)
  case decode
}

protocol APICodable: Codable { }

struct API {
  
//  static private let url = ""
  static private let url = "http://localhost:5000"
  static let monitor = NWPathMonitor()
  
  static func urlRequest(for request: APICodable.Type) -> URLRequest {
    guard var url = URL(string: url) else {
      Log.error("Error creating API URL")
      fatalError()
    }
    
    switch request {
    case is APIAccount.Type:
      url.appendPathComponent("account")
    case is APICategory.Type:
      url.appendPathComponent("category")
    case is APIBean.Type:
      url.appendPathComponent("bean")
    default:
      break
    }
    
    return URLRequest(url: url)
  }
  
  static func sendResource<T>(resource: T) -> AnyPublisher<T, Error> where T: APICodable {
    var request = urlRequest(for: T.self)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONEncoder().encode(resource)
    return URLSession.DataTaskPublisher(request: request, session: .shared)
      .tryMap { data, response in
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
          throw APIError.request(statusCode: httpResponse.statusCode)
        }
        do {
          return try JSONDecoder().decode(T.self, from: data)
        } catch {
          throw APIError.decode
      }
    }.eraseToAnyPublisher()
  }
  
  static func getAccounts() -> AnyPublisher<[APIAccount], Error> {
    return getResources()
  }
  
  static func getCategories() -> AnyPublisher<[APICategory], Error> {
    return getResources()
  }
  
  static func getBeans() -> AnyPublisher<[APIBean], Error> {
    return getResources()
  }
  
  private static func getResources<T>() -> AnyPublisher<[T], Error> where T: APICodable {
    return URLSession.DataTaskPublisher(request: urlRequest(for: T.self), session: .shared)
      .tryMap { data, response in
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
          throw APIError.request(statusCode: httpResponse.statusCode)
        }
        do {
          return try JSONDecoder().decode([T].self, from: data)
        } catch {
          throw APIError.decode
        }
    }.eraseToAnyPublisher()
  }
}
