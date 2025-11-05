//
//  OnboardingViewModelTests.swift
//  AuraTests
//
//  Created by Chabane on 04/11/2025.
//

import XCTest
@testable import Aura

final class OnboardingViewModelTests: XCTestCase {

    // Test du passage à la page suivante
    func testNextPageIncrementsUntilLastPage() {

        let viewModel = OnboardingViewModel()

        // Vérifie l’état initial
        XCTAssertEqual(viewModel.currentPage, 0, "La page initiale doit être 0")

        // Passe à la page suivante
        viewModel.nextPage()
        XCTAssertEqual(viewModel.currentPage, 1, "Après un premier nextPage(), la page doit être 1")

        // Passe encore à la page suivante
        viewModel.nextPage()
        XCTAssertEqual(viewModel.currentPage, 2, "Après un second nextPage(), la page doit être 2 (la dernière)")

        // Essaie d’aller plus loin que la dernière page
        viewModel.nextPage()
        XCTAssertEqual(viewModel.currentPage, 2, "la dernière page ne doit pas être dépassée")
    }
}
