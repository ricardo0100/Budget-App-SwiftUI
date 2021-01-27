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
    
    private var userDefaults: UserDefaults!
    private var userSession: UserSession!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        userSession = UserSession(userDefaults: userDefaults)
    }
    
    func makeSUT() -> ProfileViewModel {
        userSession = UserSession()
        userSession.saveUser(user: User(name: "Test", email: "test@test.com", token: "1234"))
        return ProfileViewModel(userSession: userSession)
    }
    
    func test_onAppear_shouldShowUserNameAndEmail() {
        let viewModel = makeSUT()
        
        XCTAssertEqual(viewModel.name, "Test")
        XCTAssertEqual(viewModel.email, "test@test.com")
    }
    
    func test_onLogout_shouldSendNilUser() {
        let viewModel = makeSUT()
        let currentUser = User(name: "Test", email: "test@test.com", token: "1234")
        
        let exp = expectValues(of: userSession.userPublisher, equalsTo: [currentUser, nil])
        viewModel.onTapLogout()
        
        wait(for: [exp.expectation], timeout: 1)
    }
}
