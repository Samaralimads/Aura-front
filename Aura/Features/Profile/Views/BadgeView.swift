//
//  BadgeView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 17/10/2025.
//

import SwiftUI

struct BadgeView: View {
    @State private var viewModel: BadgeViewModel
    @State private var selectedBadge: UserProfileResponse.Badge?
    @State private var isShowingBadgeDetails = false
    
    init(viewModel: BadgeViewModel = BadgeViewModel.preview()) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            if viewModel.unlockedBadges.isEmpty {
                emptyBadgesSection
            } else {
                
                badgeSection(title: "Débloqués", badges: viewModel.unlockedBadges, isLocked: false)
            }
            
            badgeSection(title: "À Débloquer", badges: viewModel.lockedBadges, isLocked: true)
            
            Spacer()
        }
        .padding(.vertical)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Mes Badges")
                    .font(.custom("Lexend-Bold", size: 27))
                    .foregroundColor(.primary)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchUserBadges()
        }
        .sheet(item: $selectedBadge) { badge in
            badgeDetailSheet(for: badge)
        }
    }
    
    private var emptyBadgesSection: some View {
        VStack(spacing: 16) {
            Text("Pas de badge, commencez un exercice")
                .font(.custom("Lexend-Bold", size: 22))
                .bold()
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 40)
    }
    

    @ViewBuilder
    private func badgeSection(title: String, badges: [UserProfileResponse.Badge], isLocked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.custom("Lexend-Bold", size: 22))
                .bold()
                .padding(.horizontal)
            
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 120), spacing: 5)],
                spacing: 15
            ) {
                ForEach(badges) { badge in
                    Button {
                        selectedBadge = badge
                        isShowingBadgeDetails = true
                    } label: {
                        AutonomeBadge(badge: badge, isLocked: isLocked)
                            .frame(width: 110, height: 110)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    
    @ViewBuilder
    private func badgeDetailSheet(for badge: UserProfileResponse.Badge) -> some View {
        VStack(spacing: 0) {
            Color.clear
                .padding(.top, 40)
            
            Capsule()
                .fill(Color.gray.opacity(0.7))
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 12)
            
            BadgeDetailsView(
                badge: badge,
                isLocked: viewModel.lockedBadges.contains { $0.id == badge.id }
            )
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer(minLength: 20)
        }
        .background(Color.white)
        .presentationDetents([.medium])
    }
}


#Preview {
    NavigationStack {
        BadgeView(viewModel: BadgeViewModel())
    }
}
