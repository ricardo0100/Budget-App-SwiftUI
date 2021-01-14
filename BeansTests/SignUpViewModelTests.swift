//
//  SignUpViewModelTests.swift
//  BeansTests
//
//  Created by Ricardo Gehrke on 10/01/21.
//

import XCTest
@testable import Beans

class SignUpViewModelTests: XCTestCase {

    private func makeSUT() -> SignUpViewModel {
        let settings = UserSettingsPreview()
        return SignUpViewModel(userSettings: settings)
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
        viewModel.name = "Ricardo Gehrke"
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
        viewModel.name = "Ricardo Gehrke"
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
        viewModel.name = "Ricardo Gehrke"
        viewModel.email = "ricardo@gehrke.com"
        viewModel.password = "123456"
        viewModel.onTapSignUp()
        XCTAssertNil(viewModel.nameError)
        XCTAssertNil(viewModel.emailError)
        XCTAssertNil(viewModel.passwordError)
    }
}
