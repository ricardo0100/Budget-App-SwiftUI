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
        userSettings = UserSettingsMock(user: User(name: "Test", email: "test@test.com", token: ""))
        return ProfileViewModel(userSettings: userSettings, api: APIMock())
    }
    
    func test_onAppear_shouldShowUserNameAndEmail() {
        let viewModel = makeSUT()
        XCTAssertEqual(viewModel.name, "Test")
        XCTAssertEqual(viewModel.email, "test@test.com")
    }
    
    func test_onLogout_shouldSendNilUser() {
        let viewModel = makeSUT()
        viewModel.onTapLogout()
        XCTAssertTrue(userSettings.didCallDeleteUser)
    }
    
    private var userSettings: UserSettingsMock!
}
