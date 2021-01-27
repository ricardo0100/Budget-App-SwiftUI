//
//  AccountTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 17/12/20.
//

import XCTest
@testable import Beans

class AccountTests: XCTestCase {

    func test_accountHasNoItems_shouldReturnZeroInSum() {
        let account = createAccount()
        XCTAssertEqual(account.sum(), 0)
    }
    
    func test_accountHasOneItem_shouldReturnItsValueInSum() {
        let account = createAccount()
        createItem(account: account, name: "Name", value: 1)
        XCTAssertEqual(account.sum(), 1)
    }
    
    func test_accountHasTwoItema_shouldReturnCorrectSum() {
        let account = createAccount()
        createItem(account: account, name: "Name", value: 1)
        createItem(account: account, name: "Name", value: 1)
        XCTAssertEqual(account.sum(), 2)
    }
    
    func test_twoAccounts_shouldSumOnlyItemsInAccount() {
        let account1 = createAccount()
        let account2 = createAccount()
        createItem(account: account1, name: "1", value: 1)
        createItem(account: account1, name: "2", value: 2)
        createItem(account: account2, name: "2", value: 2)
        XCTAssertEqual(account1.sum(), 3)
        XCTAssertEqual(account2.sum(), 2)
    }
    
    // MARK: Tests Setup
    
    private let context = CoreDataController.shared.container.viewContext
    
    override func tearDown() {
        CoreDataController.shared.deleteEverything()
    }
    
    @discardableResult private func createAccount() -> Account {
        let account = Account(context: context)
        account.name = "Test"
        account.color = "#000000"
        try! context.save()
        return account
    }
    
    @discardableResult private func createItem(account: Account, name: String, value: NSDecimalNumber) -> Item {
        let item = Item(context: context)
        item.name = name
        item.value = value
        item.account = account
        item.timestamp = Date()
        try! context.save()
        return item
    }
}
