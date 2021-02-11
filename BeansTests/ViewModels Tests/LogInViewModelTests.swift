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
    
    private var userDefaults: UserDefaults!
    private var userSession: UserSession!
    
    private let urlSession: URLSession = URLProtocolMock.createMockedURLSession()
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
        userSession = UserSession(userDefaults: userDefaults)
    }
    
    private func makeSUT() -> LogInViewModel {
        return LogInViewModel(urlSession: urlSession, userSession: userSession)
    }
    
    func test_whenEmailFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapLogIn()
        
        XCTAssertEqual(viewModel.emailError, "E-mail field should not be empty")
    }
    
    func test_whenPasswordIsEmpty_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.onTapLogIn()
        
        XCTAssertEqual(viewModel.passwordError, "Password field should not be empty")
    }
    
    func test_whenEmailFieldIsNotValid_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        ["ricardo", "ricardo@", "ricardo@gehrke", "ricardo@gehrke.", "@gehrke"].forEach {
            viewModel.email = $0
            viewModel.onTapLogIn()
            
            XCTAssertEqual(viewModel.emailError, "Inform a valid e-mail")
        }
    }
    
    func test_whenPasswordIsNotValid_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "12345"
        viewModel.onTapLogIn()
        
        XCTAssertEqual(viewModel.passwordError, "Password should cointain at least 6 characters")
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
    }
    
    func test_whenAPIReturnsSuccess_shouldSaveUserInUserSettings() {
        URLProtocolMock.mockAPIWithSuccessfulLoginOrSignUp()
        
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedUser = User(name: "Ricardo", email: "ricardo@gehrke.com", token: "123456")
        let exp = expectValues(of: userSession.userPublisher, equalsTo: [nil, expectedUser])
        
        viewModel.onTapLogIn()
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsUnauthorizedError_shouldShowErrorMessage() {
        URLProtocolMock.mockAPIWithNotFoundError()
        
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Login failed!", message: "The credentials provided are incorrect.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        
        viewModel.onTapLogIn()
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsServerError_shouldShowErrorMessage() {
        URLProtocolMock.mockAPIWithServerError()
        
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Server error!", message: "Something is wrong with the server, please try again later.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        
        viewModel.onTapLogIn()
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenTapsLogin_ProgressViewShouldBeUpdated() {
        let viewModel = makeSUT()
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let exp = expectValues(of: viewModel.$isInProgress, equalsTo: [false, true, false])
        viewModel.onTapLogIn()
        wait(for: [exp.expectation], timeout: 0.5)
    }
}
