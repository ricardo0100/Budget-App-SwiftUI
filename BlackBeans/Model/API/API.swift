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
  case request(description: String, statusCode: Int)
  case decode(description: String)
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
  
  static func getAccounts() -> AnyPublisher<[APIAccount], Error> {
    return getResource()
  }
  
  static func getCategories() -> AnyPublisher<[APICategory], Error> {
    return getResource()
  }
  
  static func getBeans() -> AnyPublisher<[APIBean], Error> {
    return getResource()
  }
  
  private static func getResource<T>() -> AnyPublisher<[T], Error> where T: APICodable {
    return URLSession.DataTaskPublisher(request: urlRequest(for: T.self), session: .shared)
      .tryMap { data, response in
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
          throw APIError.request(description: "Invalid response", statusCode: httpResponse.statusCode)
        }
        do {
          return try JSONDecoder().decode([T].self, from: data)
        } catch {
          throw APIError.decode(description: error.localizedDescription)
        }
    }.eraseToAnyPublisher()
  }
}
