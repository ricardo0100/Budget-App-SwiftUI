//
//  ProfileViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 06/01/21.
//

import XCTest
import Combine
@testable import Beans

class ProfileViewModelTests: XCTestCase {
    
    func makeSUT() -> ProfileViewModel {
        cancellables = []
        userSettings = UserSettings()
        userSettings.saveUser(user: User(name: "Test", email: "test@test.com", token: "1234"))
        return ProfileViewModel(userSettings: userSettings)
    }
    
    func test_onAppear_shouldShowUserNameAndEmail() {
        let viewModel = makeSUT()
        XCTAssertEqual(viewModel.name, "Test")
        XCTAssertEqual(viewModel.email, "test@test.com")
    }
    
    func test_onLogout_shouldSendNilUser() {
        let viewModel = makeSUT()
        viewModel.onTapLogout()
        let exp = expectation(description: "UserSettings gets the right user value")
        userSettings.userPublisher.sink { user in
            if user == nil {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    private var userSettings: UserSettings!
    private var cancellables: [AnyCancellable]!
}
