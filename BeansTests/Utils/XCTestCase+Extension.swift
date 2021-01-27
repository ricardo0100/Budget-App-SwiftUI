//
//  XCTestCase+Extension.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 25/01/21.
//

import XCTest
import Combine
import Foundation

extension XCTestCase {
    typealias CompetionResult = (expectation: XCTestExpectation,
                                 cancellable: AnyCancellable)
    
    func expectValues<T: Publisher>(of publisher: T,
                                   equalsTo expectedOutput: [T.Output]) -> CompetionResult where T.Output: Equatable {
        
        let exp = expectation(description: "Correct values of " + String(describing: publisher))
        var output = expectedOutput
        var receivedOutput: [T.Output] = []
        
        let cancellable = publisher.sink { _ in }
            receiveValue: { value in
                receivedOutput.append(value)
                if !output.isEmpty && value != output.removeFirst() {
                    XCTFail("output: \(receivedOutput) is different of expected: \(expectedOutput)")
                }
                if output.isEmpty {
                    exp.fulfill()
                }
            }
        return (exp, cancellable)
    }
}
