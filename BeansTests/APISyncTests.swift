//
//  APISyncTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import XCTest
@testable import Beans

class APISyncTests: XCTestCase {

    private var apiMock: APIMock!
    private var coreDataController: CoreDataController!
    
    override func setUp() {
        apiMock = APIMock()
        coreDataController = CoreDataController(inMemory: true)
    }
    
    func makeSUT() -> APISync {
        return APISync(api: apiMock, coreDataController: coreDataController)
    }
    
    func test_APISyncIsIdle_andStartsSync_shouldMakeCorrectAPIRequestsOrder() {
        let sync = makeSUT()
        sync.start()
        XCTAssertTrue(apiMock.didCallGetAccounts)
    }
}
