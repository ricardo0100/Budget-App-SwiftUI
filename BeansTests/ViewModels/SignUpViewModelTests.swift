//
//  SignUpViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import XCTest
import Combine
@testable import Beans

class SignUpViewModelTests: XCTestCase {

    var cancellables: [AnyCancellable]!
    private var userDefaults: UserDefaults!
    private var userSettings: UserSettings!
    private var api: APIMock!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        cancellables = []
    }
    
    private func makeSUT(apiMock: APIMock = APIMock()) -> SignUpViewModel {
        userSettings = UserSettings(userDefaults: userDefaults)
        api = apiMock
        return SignUpViewModel(api: api, userSettings: userSettings)
    }
    
    func test_whenNameFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        XCTAssertEqual(viewModel.nameError, "Name field should not be empty")
        XCTAssertFalse(api.didCallSignUp)
    }
    
    func test_whenEmailFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        XCTAssertEqual(viewModel.emailError, "E-mail field should not be empty")
        XCTAssertFalse(api.didCallSignUp)
    }
    
    func test_whenPasswordIsEmpty_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.onTapSignUp()
        XCTAssertEqual(viewModel.passwordError, "Password field should not be empty")
        XCTAssertFalse(api.didCallSignUp)
    }
    
    func test_whenEmailFieldIsNotValid_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        ["ricardo", "ricardo@", "ricardo@gehrke", "ricardo@gehrke.", "@gehrke"].forEach {
            viewModel.email = $0
            viewModel.onTapSignUp()
            XCTAssertEqual(viewModel.emailError, "Inform a valid e-mail")
            XCTAssertFalse(api.didCallSignUp)
        }
    }
    
    func test_whenPasswordIsNotValid_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "12345"
        viewModel.onTapSignUp()
        XCTAssertEqual(viewModel.passwordError, "Password should cointain at least 6 characters")
        XCTAssertFalse(api.didCallSignUp)
    }
    
    func test_whenErrorsAreShowing_andFieldsAreRight_andTapSignUp_shouldRemoveErrors() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        XCTAssertNotNil(viewModel.nameError)
        XCTAssertNotNil(viewModel.emailError)
        XCTAssertNotNil(viewModel.passwordError)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        XCTAssertNil(viewModel.nameError)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
        XCTAssertTrue(api.didCallSignUp)
    }
    
    func test_whenFieldsAreCorrect_AndTapSignUp_andAPIReturnsSuccess_shouldSaveUserInUserSettings() {
        let viewModel = makeSUT(apiMock: APIMock(mockUser: User(name: "Ricardo Gehrke", email: "ricardo@gehrke.com", token: "123456")))
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        
        XCTAssertTrue(api.didCallSignUp)
        let exp = expectation(description: "User is saved in UserSettings")
        userSettings.$user.sink {
            if $0?.name == "Ricardo Gehrke" {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenAPIReturnsUnauthorizedError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .wrongCredentials)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        
        let exp = expectation(description: "Sign Up fails with unauthorized error")
        viewModel.$alert.sink { alert in
            if alert?.title == "Sign Up failed!" && alert?.message == "The information provided is incorrect." {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenAPIReturnsNoConnectionError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .noConnection)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        
        let exp = expectation(description: "Sign Up fails if no internet connection")
        viewModel.$alert.sink { alert in
            if alert?.title == "Connection failed!" && alert?.message == "Please, verify your internet connection." {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenAPIReturnsServerError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .serverError)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        
        let exp = expectation(description: "Sign Up fails after server error")
        viewModel.$alert.sink { alert in
            if alert?.title == "Server error!" && alert?.message == "Something is wrong with the server, please try again later." {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
}
