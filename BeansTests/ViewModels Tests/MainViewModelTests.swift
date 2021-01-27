//
//  MainViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 27/01/21.
//

import XCTest
import Combine
@testable import Beans

class MainViewModelTests: XCTestCase {
    
    private func makeSUT() -> MainViewModel {
        MainViewModel(userSession: userSession)
    }
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        userSession = UserSession(userDefaults: userDefaults)
        cancellables = []
    }
    
    private var userSession: UserSession!
    private var userDefaults: UserDefaults!
    private var cancellables: [AnyCancellable]!
    
    func test_userSessionHasNoActiveUser_shouldShowSignUpView() {
        let viewModel = makeSUT()
        let exp = expectValues(of: viewModel.$userSessionIsActive, equalsTo: [false])
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_userSessionHasNoActiveUser_andUserSessionSavesNewUser_shouldShowTabsView() {
        let viewModel = makeSUT()
        let exp = expectValues(of: viewModel.$userSessionIsActive, equalsTo: [false, true])
        userSession.saveUser(user: User(name: "", email: "", token: ""))
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_userSessionHasActiveUser_andUserSessionDeletesCurrentUser_shouldShowSignUpView() {
        userSession.saveUser(user: User(name: "", email: "", token: ""))
        let viewModel = makeSUT()
        let exp = expectValues(of: viewModel.$userSessionIsActive, equalsTo: [true, false])
        userSession.deleteUser()
        wait(for: [exp.expectation], timeout: 1)
    }
}
