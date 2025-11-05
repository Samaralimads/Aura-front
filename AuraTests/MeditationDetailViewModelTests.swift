//
//  MeditationDetailViewModelTests.swift
//  AuraTests
//
//  Created by Chabane on 04/11/2025.
//

import XCTest
@testable import Aura

final class MeditationDetailViewModelTests: XCTestCase {

    // Test du comportement du bouton Play/Pause
    func testTogglePlayChangesState() {

        let meditation = Meditation(
            id: UUID(),
            title: "Test Meditation",
            duration: 1,
            theme: "Test",
            image: "rose-emote1",
            audio: "test.mp3",
            thumbnail: "thumb"
        )

        let viewModel = MeditationDetailViewModel(meditation: meditation)

        // Vérifie l’état initial
        XCTAssertFalse(viewModel.isPlaying, "La vue devrait être à l'arrêt au début")
        XCTAssertFalse(viewModel.isFinished, "La vue ne devrait pas être terminé au début")

        // Appuie sur Play
        viewModel.togglePlay()
        XCTAssertTrue(viewModel.isPlaying, "Après un premier toggle, la vue devrait être en lecture")

        // Appuie sur Pause
        viewModel.togglePlay()
        XCTAssertFalse(viewModel.isPlaying, "Après un second toggle, la vue devrait être en pause")
    }
}
