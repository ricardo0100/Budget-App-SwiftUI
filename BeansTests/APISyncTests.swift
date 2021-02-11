//
//  APISyncTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import XCTest
@testable import Beans

class APISyncTests: XCTestCase {
    
    private var coreDataController: CoreDataController!
    
    private let urlSession: URLSession = URLProtocolMock.createMockedURLSession()
    
    override func setUp() {
        coreDataController = CoreDataController(inMemory: true)
    }
    
    func makeSUT() -> APISync {
        return APISync(api: API(urlSession: urlSession), coreDataController: coreDataController)
    }
    
    func test_APISyncIsIdle_andStartsSync_shouldCallGetAccounts() {
        let sync = makeSUT()
        
        sync.start()
        
//        XCTAssertEqual(apiMock.getAccountsCalls, 1)
    }
    
    func test_GetAccountsSucceeds_shouldCallPostAccounts() {
        let sync = makeSUT()
        
        sync.start()
        
//        XCTAssertEqual(apiMock.getAccountsCalls, 1)
//        XCTAssertEqual(apiMock.postAccountsCalls, 1)
    }
    
    func test_GetAccountsFails_shouldCallItAgain3TimesBeforeFailing() {
        let sync = makeSUT()
        
        sync.start()
        
//        XCTAssertEqual(apiMock.getAccountsCalls, 3)
    }
}
