//
//  APIManager.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation
import Combine

class APIManager {
  
  private static let decoder = JSONDecoder()
  
  static func getAccountsPublisher() -> AnyPublisher<[APIAccount], Error> {
    let request = APIRequest.urlRequest(for: .accounts)
    return URLSession.DataTaskPublisher(request: request, session: .shared)
      .tryMap { data, _ in
        return try decoder.decode([APIAccount].self, from: data)
      }.eraseToAnyPublisher()
  }
}
