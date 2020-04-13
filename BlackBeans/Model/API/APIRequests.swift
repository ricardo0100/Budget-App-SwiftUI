//
//  APIRequests.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 13/04/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

enum APIRequest {
  
  case accounts
  
  static func urlRequest(for request: APIRequest) -> URLRequest {
    guard var url = URL(string: "https://black-beans.herokuapp.com") else {
      Log.error("Error creating API URL")
      fatalError()
    }
    
    switch request {
    case .accounts:
      url.appendPathComponent("account")
      return URLRequest(url: url)
    }
  }
  
}
