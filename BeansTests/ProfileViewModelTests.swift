//
//  ProfileViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import XCTest
@testable import Beans

class ProfileViewModelTests: XCTestCase {
    
    func makeSUT() -> ProfileViewModel {
        return ProfileViewModel(userManager: UserManagerMock(name: "Test", email: "test@test.com", token: "1234"))
    }
    
    func test_onAppear_shouldShowUserNameAndEmail() {
        let viewModel = makeSUT()
        XCTAssertEqual(viewModel.name, "Test")
        XCTAssertEqual(viewModel.email, "test@test.com")
    }
    
    func test_onLogout_shouldSendNilUser() {
        let viewModel = makeSUT()
        viewModel.onTapLogout()
        XCTAssertEqual(viewModel.name, "")
        XCTAssertEqual(viewModel.email, "")
    }
    
    private var context = PersistenceController.shared.container.viewContext
}
