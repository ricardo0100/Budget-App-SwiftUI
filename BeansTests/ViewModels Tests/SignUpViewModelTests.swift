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

    private var userDefaults: UserDefaults!
    
    private var userSession: UserSession!
    
    private let urlSession: URLSession = URLProtocolMock.createMockedURLSession()
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }
    
    private func makeSUT() -> SignUpViewModel {
        userSession = UserSession(userDefaults: userDefaults)
        return SignUpViewModel(urlSession: urlSession, userSession: userSession)
    }
    
    func test_whenNameFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        
        XCTAssertEqual(viewModel.nameError, "Name field should not be empty")
    }
    
    func test_whenEmailFieldIsEmpty_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        
        XCTAssertEqual(viewModel.emailError, "E-mail field should not be empty")
    }
    
    func test_whenPasswordIsEmpty_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.onTapSignUp()
        
        XCTAssertEqual(viewModel.passwordError, "Password field should not be empty")
    }
    
    func test_whenEmailFieldIsNotValid_andTapSingUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        ["ricardo", "ricardo@", "ricardo@gehrke", "ricardo@gehrke.", "@gehrke"].forEach {
            viewModel.email = $0
            viewModel.onTapSignUp()
            
            XCTAssertEqual(viewModel.emailError, "Inform a valid e-mail")
        }
    }
    
    func test_whenPasswordIsNotValid_andTapSignUp_shouldShowErrorMessage() {
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "12345"
        viewModel.onTapSignUp()
        
        XCTAssertEqual(viewModel.passwordError, "Password should cointain at least 6 characters")
    }
    
    func test_whenErrorsAreShowing_andFieldsAreRight_andTapSignUp_shouldRemoveErrors() {
        let viewModel = makeSUT()
        viewModel.onTapSignUp()
        
        XCTAssertNotNil(viewModel.nameError)
        XCTAssertNotNil(viewModel.emailError)
        XCTAssertNotNil(viewModel.passwordError)
        
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        
        XCTAssertNil(viewModel.nameError)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
    }
    
    func test_whenAPIReturnsSuccess_shouldSaveUserInUserSettings() {
        URLProtocolMock.mockAPIWithSuccessfulLoginOrSignUp()
        
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedUser = User(name: "Ricardo", email: "ricardo@gehrke.com", token: "123456")
        let exp = expectValues(of: userSession.userPublisher, equalsTo: [nil, expectedUser])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsUnauthorizedError_shouldShowErrorMessage() {
        URLProtocolMock.mockAPIWithNotFoundError()
        
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Sign Up failed!", message: "The information provided is incorrect.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsServerError_shouldShowErrorMessage() {
        URLProtocolMock.mockAPIWithServerError()
        
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Server error!", message: "Something is wrong with the server, please try again later.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenTapsSignup_ProgressViewShouldBeUpdated() {
        let viewModel = makeSUT()
        viewModel.name = "Ricardo"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let exp = expectValues(of: viewModel.$isInProgress, equalsTo: [false, true, false])
        viewModel.onTapSignUp()
        wait(for: [exp.expectation], timeout: 0.5)
    }
}
