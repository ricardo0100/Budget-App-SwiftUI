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
        coreDataController = CoreDataController(inMemory: true)
    }
    
    func makeSUT() -> APISync {
        return APISync(api: apiMock, coreDataController: coreDataController)
    }
    
    func test_APISyncIsIdle_andStartsSync_shouldCallGetAccounts() {
        apiMock = APIMock()
        let sync = makeSUT()
        
        sync.start()
        
        XCTAssertEqual(apiMock.getAccountsCalls, 1)
    }
    
    func test_GetAccountsSucceeds_shouldCallPostAccounts() {
        apiMock = APIMock()
        let sync = makeSUT()
        
        sync.start()
        
        XCTAssertEqual(apiMock.getAccountsCalls, 1)
        XCTAssertEqual(apiMock.postAccountsCalls, 1)
    }
    
    func test_GetAccountsFails_shouldCallItAgain3TimesBeforeFailing() {
        apiMock = APIMock(mockError: .serverError)
        let sync = makeSUT()
        
        sync.start()
        
//        XCTAssertEqual(apiMock.getAccountsCalls, 3)
    }
}
