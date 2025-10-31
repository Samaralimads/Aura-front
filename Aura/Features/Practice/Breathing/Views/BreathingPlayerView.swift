//
//  BreathingPlayerView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct BreathingPlayerView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var timer : Int = 0
    @Environment(\.dismiss) var dismiss
    @State private var badgeViewModel = BadgeViewModel()
    private let currentBadgeId = "55555555-5555-5555-5555-555555555555"
    private let userEmail = "mehdi@simplon.com"


    
    public var body: some View {
        ZStack {
            // MARK: - INTÉGRATION ANIMATIONS
            if viewModel.indexOrder == 1 {
                WaveEffectView(viewModel: viewModel)
                    .ignoresSafeArea()
            } else if viewModel.indexOrder == 2 {
                MontainAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            } else if viewModel.indexOrder == 3 {
                SunAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            } else {
                MoonAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            
            // MARK: - GESTION PLAYER ET FIN DU CYCLE
            if !viewModel.isFinished {
                PlayerControllerView(viewModel: viewModel)
            } else {
                VStack(spacing: 10) {
                    Text("Félicitations !")
                        .foregroundColor(.white)
                        .font(.custom("Lexend-Medium", size: 40))
                        .padding(.bottom, 10)
                    Text("Vous avez terminé votre séance \nde respiration.")
                        .foregroundColor(.white)
                        .font(.custom("Lexend-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    
                    Button{
                        dismiss()
                    } label: {
                        Text("Valider")
                            .font(.custom("Lexend-medium", size: 17))
                            .foregroundStyle(.black)
                            .frame(width: 349, height: 48)
                            .cornerRadius(25)
                            .glassEffect(.regular.interactive())
                            .padding(.top, 40)
                    }
                }
                .padding(.bottom, 150)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(17)
            }
        }
        .onChange(of: viewModel.isFinished) { _, newValue in
            if newValue {
                Task {
                    await badgeViewModel.fetchUserBadges()
                    if !badgeViewModel.unlockedBadges.contains(where: { $0.id == currentBadgeId }) {
                        await badgeViewModel.unlockBadge(
                            badgeId: currentBadgeId,
                            email: userEmail
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    BreathingPlayerView(
        viewModel: BreathingPlayerViewModel(
            inhaleD: 2,
            holdD: 1,
            exhaleD: 2,
            nbOfCycles: 1,
            indexOrder: 3,
            audio: "night"
        )
    )
}
