//
//  OnboardingViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 25/10/2025.
//

import Foundation

@Observable
class OnboardingViewModel {
    var currentPage = 0
    let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            title: "Bienvenue !",
            description: "Prends quelques instants pour toi. Suis ton humeur au quotidien et observe ton évolution, pas à pas.",
            imageName: "perso1-violet",
            backgroundColor: .violetClair
        ),
        OnboardingPage(
            id: 1,
            title: "Méditez",
            description: "Détends ton esprit avec de courtes séances guidées. Quelques minutes suffisent pour retrouver calme et clarté.",
            imageName: "perso2-jaune",
            backgroundColor: .jauneClair
        ),
        OnboardingPage(
            id: 2,
            title: "Respirez",
            description: "Apaise ton corps grâce à des exercices de respiration simples et efficaces. Inspire, expire… et profite de l’instant.",
            imageName: "perso3-vert",
            backgroundColor: .vertClair
        )
    ]
    
    var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    var progress: CGFloat {
        CGFloat(currentPage) / CGFloat(pages.count - 1)
    }
    
    func nextPage() {
        guard currentPage < pages.count - 1 else { return }
        currentPage += 1
    }
}

