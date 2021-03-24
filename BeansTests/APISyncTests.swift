//
//  APISyncTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 28/01/21.
//

import XCTest
import Combine
import CoreData
@testable import Beans

class APISyncTests: XCTestCase {
    
    private var coreDataController: CoreDataController!
    private var cancellables: [AnyCancellable]!
    
    private let urlSession: URLSession = URLProtocolMock.createMockedURLSession()
    
    override func setUp() {
        coreDataController = CoreDataController.tests
        coreDataController.deleteEverything()
        cancellables = []
    }
    
    func makeSUT() -> Sync {
        return Sync(api: API(urlSession: urlSession), coreDataController: coreDataController)
    }
    
    func test_startSync_shouldCallGetAccounts_andSaveInCoreData() {
        URLProtocolMock.mockAPIWithSuccessfulResponse(body: """
        [{
          "id": 1,
          "name": "Maya's Bank"
        }]
        """)
        let sync = makeSUT()
        
        let exp = expectValues(of: sync.status, equalsTo: [.idle, .inProgress, .idle])
        
        sync.startSync()
        
        wait(for: [exp.expectation], timeout: 1)
        
        let accounts = fetchAllAccounts()
        
        XCTAssertEqual(accounts.first?.remoteID, 1)
        XCTAssertEqual(accounts.first?.name, "Maya's Bank")
    }
    
    func test_startSync_shouldSaveNewAccounts_andUpdateExistingOnes() {
        URLProtocolMock.mockAPIWithSuccessfulResponse(body: """
        [{
          "id": 1,
          "name": "Maya's Bank"
        },
        {
          "id": 2,
          "name": "Feijão's Bank",
        }]
        """)
        createAccount(remoteID: 1, name: "Bank")
        
        let sync = makeSUT()
        
        let exp = expectValues(of: sync.status, equalsTo: [.idle, .inProgress, .idle])
        sync.startSync()
        wait(for: [exp.expectation], timeout: 1)
        
        let accounts = fetchAllAccounts()
        
        XCTAssertEqual(accounts.count, 2)
        XCTAssertEqual(accounts.filter { $0.name == "Maya's Bank" }.count, 1)
        XCTAssertEqual(accounts.filter { $0.name == "Feijão's Bank" }.count, 1)
    }
    
    func test_GetAccountsFails_shouldCallItAgain3TimesBeforeFailing() {
        let sync = makeSUT()
        
        sync.startSync()
        
//        XCTAssertEqual(apiMock.getAccountsCalls, 3)
    }
    
    // MARK: Tests helpers
    
    @discardableResult private func createAccount(remoteID: Int, name: String) -> Account {
        let context = coreDataController.container.viewContext
        let account = Account(context: context)
        account.remoteID = Int64(remoteID)
        account.name = name
        
        try! context.save()
        
        return account
    }
    
    private func fetchAllAccounts() -> [Account] {
        let request: NSFetchRequest<Account> = Account.fetchRequest()
        return try! coreDataController.container.viewContext.fetch(request)
    }
}
