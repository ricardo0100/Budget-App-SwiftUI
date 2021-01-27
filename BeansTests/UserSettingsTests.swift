////
////  UserSettingsTests.swift
////  BeansTests
////
////  Created by Ricardo Gehrke on 21/01/21.
////
//
//import XCTest
//import Combine
//@testable import Beans
//
//class UserSettingsTests: XCTestCase {
//
//    func makeSUT() -> UserSettings {
//        return UserSettings(userDefaults: userDefaults)
//    }
//
//    func test_whenSettingsStateIsEmpty_andLoads_shouldReturnNil() {
//        let settings = makeSUT()
//        let exp = expectation(description: "User is not nil")
//        
//        settings.$user.sink { user in
//            if user == nil {
//                exp.fulfill()
//            }
//        }.store(in: &cancellables)
//        wait(for: [exp], timeout: 1)
//    }
//    
//    func test_whenSavesUser_andLoads_shouldReturnSavedUser() {
//        let settings = makeSUT()
//        settings.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
//        
//        let exp = expectation(description: "User is not nil")
//        settings.$user.sink { user in
//            if user?.name == "Test" {
//                exp.fulfill()
//            }
//        }.store(in: &cancellables)
//        wait(for: [exp], timeout: 1)
//    }
//    
//    func test_whenSettingsContainsUser_andDeletes_shouldReturnNil() {
//        let settings = makeSUT()
//        settings.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
//        settings.deleteUser()
//        
//        let exp = expectation(description: "User is nil")
//        settings.$user.sink { user in
//            if user == nil {
//                exp.fulfill()
//            }
//        }.store(in: &cancellables)
//        wait(for: [exp], timeout: 1)
//    }
//    
//    func test_whenSettingsContainUser_andInits_shouldUpdatePublisher() {
//        var settings = makeSUT()
//        settings.saveUser(user: User(name: "Test", email: "Test", token: "Test"))
//        settings = makeSUT()
//        
//        let exp = expectation(description: "User is not nil")
//        settings.$user.sink { user in
//            if user != nil {
//                exp.fulfill()
//            }
//        }.store(in: &cancellables)
//        wait(for: [exp], timeout: 1)
//    }
//    
//    override func setUp() {
//        cancellables = []
//        userDefaults = UserDefaults(suiteName: #file)
//        userDefaults.removePersistentDomain(forName: #file)
//    }
//    
//    var userDefaults: UserDefaults!
//    var cancellables: [AnyCancellable]!
//}
