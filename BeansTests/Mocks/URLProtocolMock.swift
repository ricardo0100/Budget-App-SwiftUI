//
//  URLProtocolMock.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 10/02/21.
//

import Foundation

class URLProtocolMock: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func stopLoading() {
        
    }
    
    override func startLoading() {
        guard let handler = URLProtocolMock.requestHandler else {
            return
        }
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch  {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    static func createMockedURLSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [Self.self]
        let urlSession = URLSession(configuration: config)
        return urlSession
    }
    
    static func mockAPIWithSuccessfulLoginOrSignUp() {
        requestHandler = { request in
            let exampleData = """
        {
          "name": "Ricardo",
          "email": "ricardo@gehrke.com",
          "token": "123456"
        }
        """.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
            return (response, exampleData)
        }
    }
    
    static func mockAPIWithNotFoundError() {
        requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: "2.0", headerFields: nil)!
            return (response, Data())
        }
    }
    
    static func mockAPIWithServerError() {
        requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: "2.0", headerFields: nil)!
            return (response, Data())
        }
    }
}
