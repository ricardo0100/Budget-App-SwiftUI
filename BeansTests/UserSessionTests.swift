//
//  UserSessionTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 21/01/21.
//

import XCTest
import Combine
@testable import Beans

class UserSessionTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    var cancellables: [AnyCancellable]!
    
    override func setUp() {
        cancellables = []
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }
    
    func makeSUT() -> UserSession {
        return UserSession(userDefaults: userDefaults)
    }

    func test_whenSettingsStateIsEmpty_andLoads_shouldReturnNil() {
        let userSession = makeSUT()
        let exp = expectation(description: "User is not nil")
        
        userSession.userPublisher.sink { user in
            if user == nil {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenSavesUser_andLoads_shouldReturnSavedUser() {
        let userSession = makeSUT()
        userSession.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
        
        let exp = expectation(description: "User is not nil")
        userSession.userPublisher.sink { user in
            if user?.name == "Test" {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenSettingsContainsUser_andDeletes_shouldReturnNil() {
        let userSession = makeSUT()
        userSession.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
        userSession.deleteUser()
        
        let exp = expectation(description: "User is nil")
        userSession.userPublisher.sink { user in
            if user == nil {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenSettingsContainUser_andInits_shouldUpdatePublisher() {
        var userSession = makeSUT()
        userSession.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
        userSession = makeSUT()
        
        let exp = expectation(description: "User is not nil")
        userSession.userPublisher.sink { user in
            if user != nil {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
}
