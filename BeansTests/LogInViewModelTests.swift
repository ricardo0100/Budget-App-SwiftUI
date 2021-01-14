//
//  LogInViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 11/01/21.
//

import XCTest
@testable import Beans

class LogInViewModelTests: XCTestCase {
    
    private func makeSUT() -> LogInViewModel {
        return LogInViewModel(userSettings: UserSettingsPreview())
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
    
    func test_whenErrorsAreShowing_andFieldsAreRight_andTapSignUp_shouldRemoveErrors() {
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
}
