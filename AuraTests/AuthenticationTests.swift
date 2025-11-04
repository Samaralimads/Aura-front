//
//  AuthenticationTests.swift
//  Aura
//
//  Created by Mehdi Legoullon on 04/11/2025.
//

import XCTest
@testable import Aura

final class AuthenticationValidationTests: XCTestCase {
    
    var loginViewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        loginViewModel = LoginViewModel(authState: AppState())
    }
    
    override func tearDown() {
        loginViewModel = nil
        super.tearDown()
    }
    
    func testValidation_WhenEmailIsEmpty_ShouldFail() {
        // Arrange
        loginViewModel.email = ""
        loginViewModel.password = "motdepasse123"
        
        // Act
        let isValid = loginViewModel.validateBasicCredentials()
        
        // Assert
        XCTAssertFalse(isValid, "La validation doit échouer si l'email est vide")
    }
    
    func testValidation_WhenPasswordIsEmpty_ShouldFail() {
        // Arrange
        loginViewModel.email = "mehdi@example.com"
        loginViewModel.password = ""
        
        // Act
        let isValid = loginViewModel.validateBasicCredentials()
        
        // Assert
        XCTAssertFalse(isValid, "La validation doit échouer si le mot de passe est vide")
    }
    
    func testValidation_WhenCredentialsAreNotEmpty_ShouldSucceed() {
        // Arrange
        loginViewModel.email = "mehdi@example.com"
        loginViewModel.password = "motdepasse123"
        
        // Act
        let isValid = loginViewModel.validateBasicCredentials()
        
        // Assert
        XCTAssertTrue(isValid, "La validation doit réussir si l'email et le mot de passe ne sont pas vides")
    }
}

extension LoginViewModel {
    func validateBasicCredentials() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
}
