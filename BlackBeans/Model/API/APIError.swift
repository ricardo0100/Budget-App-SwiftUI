//
//  APIError.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 18/06/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import Foundation

enum APIError: Error {
    case noInternet
    case url(error: URLError?)
    case server(statusCode: Int, url: URL?, body: String)
    case encoder(error: EncodingError?)
    case decoder(error: DecodingError?)
    case unknown
    
    var debugDescription: String {
        switch self {
        case .noInternet:
            return "Internet unavailable"
        case .url(let error):
            return "URL error -> \(error.debugDescription)"
        case .server(let statusCode, let url, let message):
            return "Server error code \(statusCode) in \(url?.absoluteString ?? .empty) -> \(message)"
        case .encoder(let error):
            return "Encoding error -> \(error?.failureReason ?? .empty)"
        case .decoder(let error):
            return "Decoding error -> \(error?.failureReason ?? .empty)"
        case .unknown:
            return "Unknown API Error"
        }
    }
    
    var userMessage: String {
        switch self {
        case .server(_, _, let message):
            return message
        default:
            return .empty
        }
    }
}
