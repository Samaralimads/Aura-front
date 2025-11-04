//
//  AuthenticationTests.swift
//  Aura
//
//  Created by Mehdi Legoullon on 04/11/2025.
//

import XCTest
@testable import Aura

final class AuthenticationTests: XCTestCase {
    
    // SUT: System Under Test
    var loginViewModel: LoginViewModel!
    
    override func setUpWithError() throws {
        // Arrange: Initialiser le SUT avant chaque test
        loginViewModel = LoginViewModel()
    }
    
    override func tearDownWithError() throws {
        // Libérer le SUT après chaque test
        loginViewModel = nil
    }
    
    // Test: Vérifier que la validation de l'email retourne false si l'email est invalide
    func testLoginViewModel_WhenInvalidEmailProvided_ShouldReturnFalse() throws {
        // Arrange
        let invalidEmail = "mehdi.example.com"
        let password = "motdepasse123"
        let expectedResult = false
        
        // Act
        let isValid = loginViewModel.validateCredentials(email: invalidEmail, password: password)
        
        // Assert
        XCTAssertEqual(isValid, expectedResult, "La validation doit échouer pour un email invalide")
    }
    
    // Test: Vérifier que la validation retourne true si l'email et le mot de passe sont valides
    func testLoginViewModel_WhenValidCredentialsProvided_ShouldReturnTrue() throws {
        // Arrange
        let validEmail = "mehdi@example.com"
        let validPassword = "motdepasse123"
        let expectedResult = true
        
        // Act
        let isValid = loginViewModel.validateCredentials(email: validEmail, password: validPassword)
        
        // Assert
        XCTAssertEqual(isValid, expectedResult, "La validation doit réussir pour des identifiants valides")
    }
}
