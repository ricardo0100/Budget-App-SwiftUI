//
//  EditItemViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 28/11/20.
//

import XCTest
import CoreData
import Combine
import SwiftUI
@testable import Beans

class EditItemViewModelTests: XCTestCase {
    
    private var context = CoreDataController.tests.container.viewContext
    private var cancellables: [AnyCancellable]!
    private let emptyNameFieldErrorMessage = "Name should not be empty"
    
    override func setUp() {
        cancellables = []
        CoreDataController.tests.deleteEverything()
    }
    
    private func makeSUT(item: Item? = nil, locale: Locale = .current) -> EditItemViewModel {
        let viewModel = EditItemViewModel(item: item,
                                          context: context,
                                          locale: locale)
        return viewModel
    }
    
    // MARK: Unit Tests
    
    func test_whenIsNewItem_shouldShowNewItemInTitle() {
        let viewModel = makeSUT()
        
        XCTAssertEqual(viewModel.title, "New Item")
    }

//    func test_whenIsExistingItem_shouldShowItemNameInTitle() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "Bananas 🍌", value: 1, account: createAccount(name: "Bank")))
//
//        XCTAssertEqual(viewModel.title, "Bananas 🍌")
//    }
//
//    func test_whenIsNewItem_shouldShowEmptyNameField() {
//        let viewModel = makeSUT()
//
//        XCTAssertEqual(viewModel.name, "")
//    }
//
//    func test_whenIsExistingItem_shouldShowItemNameInNameField() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "Bananas 🍌", value: 1, account: createAccount(name: "Bank")))
//
//        XCTAssertEqual(viewModel.name, "Bananas 🍌")
//    }
//
//    func test_whenIsNewItem_shouldShowZeroInValueField() {
//        let viewModel = makeSUT()
//
//        XCTAssertEqual(viewModel.value, 0)
//    }
//
//    func test_whenIsExistingItem_shouldShowItemValueInValueField() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "Bananas 🍌", value: 1.99, account: createAccount(name: "Bank")))
//
//        XCTAssertEqual(viewModel.value, 1.99)
//    }
//
//    func test_whenIsExistingItem_shouldFillAccountsOptions() {
//        createAccount(name: "1")
//        let account = createAccount(name: "2")
//        let viewModel = makeSUT(model: createModelWithItem(name: "Bananas 🍌", value: 1, account: account))
//
//        XCTAssertEqual(viewModel.availableAccounts.count, 2)
//    }
    
    func test_whenNameFieldIsEmpty_andTapSave_shouldShowNameIsEmptyError() {
        let viewModel = makeSUT()
        
        viewModel.onTapSave()
        XCTAssertEqual(viewModel.nameError, emptyNameFieldErrorMessage)
    }

    func test_whenNameFieldIsNotEmpty_andIsShowingNameIsEmptyError_andTapSave_shouldNotShowError() {
        createAccount(name: "Test")
        let viewModel = makeSUT()
        
        viewModel.onTapSave()
        XCTAssertEqual(viewModel.nameError, emptyNameFieldErrorMessage)
        viewModel.name = "Bananas 🍌"
        viewModel.onTapSave()
        XCTAssertEqual(viewModel.nameError, nil)
    }

    func test_whenNameFieldIsShowingError_andViewAppears_shouldNotShowErrorForNewItem() {
        let viewModel = makeSUT()
        viewModel.nameError = emptyNameFieldErrorMessage
        
        XCTAssertEqual(viewModel.nameError, nil)
    }

    func test_whenIsNewItem_andNameFieldIsFilled_andSaveIsTapped_shouldSaveANewItem() {
        createAccount(name: "Bank")
        let viewModel = makeSUT()
        viewModel.name = "Avocado 🥑"
        viewModel.value = 1.99
        viewModel.onTapSave()
        
        let items = retrieveAllItems()
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "Avocado 🥑")
        XCTAssertEqual(items.first?.value, NSDecimalNumber(decimal: 1.99))
    }
    
    func test_isNewItem_andNameFieldIsNotFilled_andSaveIsTapped_shouldNotSave() {
        let viewModel = makeSUT()
        viewModel.onTapSave()
        
        let items = retrieveAllItems()
        XCTAssertEqual(items.count, 0)
    }
    
//    func test_whenIsExistingItem_andNameFieldIsFilled_andSaveIsTapped_shouldSaveTheExistingItem() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "Banana 🍌", value: 1, account: createAccount(name: "Bank")))
//        viewModel.name = "Avocado 🥑"
//        viewModel.value = 1.99
//        viewModel.onTapSave()
//
//        let items = retrieveAllItems()
//        XCTAssertEqual(items.count, 1)
//        XCTAssertEqual(items.first?.name, "Avocado 🥑")
//        XCTAssertEqual(items.first?.value, NSDecimalNumber(decimal: 1.99))
//    }
//
//    func test_whenIsSaved_shouldDismiss() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "Banana 🍌", value: 1, account: createAccount(name: "Bank")))
//        viewModel.name = "Avocado 🥑"
//        viewModel.value = 1.99
//        viewModel.onTapSave()
//
//        XCTAssertNil(editItemModelBinding.wrappedValue)
//    }
//
//    func test_whenCannotSave_shouldNotDismiss() {
//        let viewModel = makeSUT(model: createModelWithItem(name: "", value: 1, account: createAccount(name: "Bank")))
//        viewModel.onTapSave()
//
//        XCTAssertNotNil(editItemModelBinding.wrappedValue)
//    }
    
//    func test_whenIsExistingItem_andSave_willUpdateTimestamp() {
//        let account = createAccount(name: "Bank")
//        let model = createModelWithItem(name: "Item", value: 1, account: account)
//
//        let oldTimestamp = model.item?.timestamp
//        let viewModel = makeSUT(model: model)
//        viewModel.onTapSave()
//        let newTimestamp = model.item?.timestamp
//        XCTAssert(newTimestamp! > oldTimestamp!)
//    }
//
//    // MARK: Helpers
//
//    private func createModelWithItem(name: String, value: NSDecimalNumber, account: Account?) -> EditItemModel {
//        let item = Item(context: context)
//        item.name = name
//        item.value = value
//        item.account = account
//        item.timestamp = Date()
//        try! context.save()
//        return EditItemModel(item: item)
//    }
    
    @discardableResult private func createAccount(name: String) -> Account {
        let account = Account(context: context)
        account.name = name
        account.color = "#FF0000"
        try! context.save()
        return account
    }
    
    private func retrieveAllItems() -> [Item] {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.name, ascending: true)]
        let result = try! context.fetch(request)
        return result
    }
}
