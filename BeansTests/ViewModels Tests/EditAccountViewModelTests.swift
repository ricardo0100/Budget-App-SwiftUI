//
//  EditAccountViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 03/12/20.
//

import XCTest
import Combine
import SwiftUI
import CoreData
@testable import Beans

class EditAccountViewModelTests: XCTestCase {
    
    override func setUp() {
        CoreDataController.tests.deleteEverything()
    }
    
    private func makeSUT(withExistingAccount: Bool = false) -> EditAccountViewModel {
        return EditAccountViewModel(account: withExistingAccount ? createTestAccount() : nil,
                                    context: CoreDataController.tests.container.viewContext)
    }
    
    func test_whenIsNewAccount_shouldShowNewAccountInTitle() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        XCTAssertEqual(viewModel.title, "New Account")
    }
    
    func test_whenIsNewAccount_shouldShowEmptyNameField() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        XCTAssertEqual(viewModel.name, "")
    }
    
    func test_whenIsExistingAccount_shouldShowAccountNameInTitle() {
        let viewModel = makeSUT(withExistingAccount: true)
        viewModel.onAppear()
        XCTAssertEqual(viewModel.title, "The Bank 💰")
    }
    
    func test_whenIsExistingAccount_shouldShowAccountNameInNameField() {
        let viewModel = makeSUT(withExistingAccount: true)
        viewModel.onAppear()
        XCTAssertEqual(viewModel.name, "The Bank 💰")
    }
    
    func test_whenIsExistingAccount_shouldShowColorInColorField() {
        let viewModel = makeSUT(withExistingAccount: true)
        viewModel.onAppear()
        XCTAssertEqual(viewModel.color, "#FF0000")
    }
    
    func test_whenIsNewAccountAndNameIsEmpty_andTappedSave_shouldShowNameFieldEmptyError() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        viewModel.onSave()
        XCTAssertEqual(viewModel.nameError, "Name should not be empty")
    }
    
    func test_whenIsShowingNameFieldEmptyError_andNameFieldIsNotEmpty_andTappedSave_shouldNotShowError() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        viewModel.onSave()
        viewModel.name = "T"
        viewModel.onSave()
        XCTAssertEqual(viewModel.nameError, nil)
    }
    
    func test_whenIsNewItem_AndFieldNameIsEmpty_andTappedSave_shouldNotSaveInContext() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        viewModel.onSave()
        
        let accounts = retrieveAllAccounts()
        XCTAssertEqual(accounts.count, 0)
    }
    
    func test_whenIsNewItem_AndFieldNameIsNotEmpty_andTappedSave_shouldSaveInContext() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        viewModel.name = "The Bank 💰"
        viewModel.color = "#FFBBAAFF"
        viewModel.onSave()
        
        let accounts = retrieveAllAccounts()
        XCTAssertEqual(accounts.count, 1)
        XCTAssertEqual(accounts.first?.name, "The Bank 💰")
        XCTAssertEqual(accounts.first?.color, "#FFBBAAFF")
    }
    
    func test_whenIsNewItem_AndFieldNameIsNotEmpty_andTappedSave_shouldDismiss() {
        let viewModel = makeSUT()
        viewModel.onAppear()
        viewModel.name = "The Bank 💰"
        viewModel.onSave()
        
//        XCTAssertNil(modelBinding.wrappedValue)
    }
    
    func test_whenIsExistingItem_shouldSaveDataInSameObject() {
        let viewModel = makeSUT(withExistingAccount: true)
        viewModel.onAppear()
        viewModel.name = "Test"
        viewModel.onSave()
        
        let accounts = retrieveAllAccounts()
        XCTAssertEqual(accounts.count, 1)
        XCTAssertEqual(accounts.first?.name, "Test")
    }
    
    // MARK: Helpers
    
    private func createTestAccount(with name: String = "The Bank 💰") -> Account {
        let context = CoreDataController.tests.container.viewContext
        let account = Account(context: context)
        account.name = name
        account.color = "#FF0000"
        try! context.save()
        return account
    }
    
    private func retrieveAllAccounts() -> [Account] {
        let context = CoreDataController.tests.container.viewContext
        return try! context.fetch(Account.fetchRequest())
    }
}
