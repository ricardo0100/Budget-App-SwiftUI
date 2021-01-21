//
//  LogInViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 11/01/21.
//

import XCTest
import Combine
@testable import Beans

class LogInViewModelTests: XCTestCase {
    
    private func makeSUT(apiMock: APIMock = APIMock()) -> LogInViewModel {
        userSettings = UserSettings()
        cancellables = []
        self.api = apiMock
        return LogInViewModel(api: apiMock, userSettings: userSettings)
    }
    
    func test_whenEmailFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapLogIn()
        XCTAssertEqual(viewModel.emailError, "E-mail field should not be empty")
        XCTAssertFalse(api.didCallLogin)
    }
    
    func test_whenPasswordIsEmpty_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.onTapLogIn()
        XCTAssertEqual(viewModel.passwordError, "Password field should not be empty")
        XCTAssertFalse(api.didCallLogin)
    }
    
    func test_whenEmailFieldIsNotValid_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        ["ricardo", "ricardo@", "ricardo@gehrke", "ricardo@gehrke.", "@gehrke"].forEach {
            viewModel.email = $0
            viewModel.onTapLogIn()
            XCTAssertEqual(viewModel.emailError, "Inform a valid e-mail")
            XCTAssertFalse(api.didCallLogin)
        }
    }
    
    func test_whenPasswordIsNotValid_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "12345"
        viewModel.onTapLogIn()
        XCTAssertEqual(viewModel.passwordError, "Password should cointain at least 6 characters")
        XCTAssertFalse(api.didCallLogin)
    }
    
    func test_whenErrorsAreShowing_andFieldsAreRight_andUserTapsSignUp_shouldRemoveErrors() {
        let viewModel = makeSUT()
        viewModel.onTapLogIn()
        XCTAssertNotNil(viewModel.emailError)
        XCTAssertNotNil(viewModel.passwordError)
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapLogIn()
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
        XCTAssertTrue(api.didCallLogin)
    }
    
    func test_whenFieldsAreCorrect_APIReturnsSuccess_andUserTapsLogin_shouldSaveUserInUserSettings() {
        let apiMock = APIMock(mockUser: User(name: "Ricardo", email: "ricardo@gehrke.com", token: "1234"))
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapLogIn()
        
        let exp = expectation(description: "Login success")
        userSettings.userPublisher.sink {
            if $0?.name == "Ricardo", $0?.email == "ricardo@gehrke.com", $0?.token == "1234" {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenAPIReturnsUnauthorizedError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .wrongCredentials)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapLogIn()
        
        let exp = expectation(description: "Login fails with unauthorized error")
        viewModel.$alert.sink { alert in
            if alert?.title == "Login failed!" && alert?.message == "The credentials provided are incorrect." {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_whenAPIReturnsNoConnectionError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .noConnection)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapLogIn()
        
        let exp = expectation(description: "Login fails if no internet connection")
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
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapLogIn()
        
        let exp = expectation(description: "Login fails after server error")
        viewModel.$alert.sink { alert in
            if alert?.title == "Server error!" && alert?.message == "Something is wrong with the server, please try again later." {
                exp.fulfill()
            }
        }.store(in: &cancellables)
        
        wait(for: [exp], timeout: 1)
    }
       
    
    private var userSettings: UserSettings!
    private var api: APIMock!
    private var cancellables: [AnyCancellable]!
}
