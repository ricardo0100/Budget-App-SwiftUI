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
    private var api: APIMock!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
        userDefaults.removePersistentDomain(forName: #file)
    }
    
    private func makeSUT(apiMock: APIMock = APIMock()) -> SignUpViewModel {
        userSession = UserSession(userDefaults: userDefaults)
        api = apiMock
        return SignUpViewModel(api: api, userSession: userSession)
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
        
        let expectedUser = User(name: "Ricardo Gehrke", email: "ricardo@gehrke.com", token: "123456")
        let exp = expectValues(of: userSession.userPublisher, equalsTo: [nil, expectedUser])
        viewModel.onTapSignUp()
        
        XCTAssertTrue(api.didCallSignUp)
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsUnauthorizedError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .wrongCredentials)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Sign Up failed!", message: "The information provided is incorrect.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsNoConnectionError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .noConnection)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Connection failed!", message: "Please, verify your internet connection.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
    
    func test_whenAPIReturnsServerError_shouldShowErrorMessage() {
        let apiMock = APIMock(mockError: .serverError)
        let viewModel = makeSUT(apiMock: apiMock)
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        
        let expectedAlert = AlertMessage(title: "Server error!", message: "Something is wrong with the server, please try again later.")
        let exp = expectValues(of: viewModel.$alert, equalsTo: [nil, expectedAlert])
        viewModel.onTapSignUp()
        
        wait(for: [exp.expectation], timeout: 1)
    }
}
