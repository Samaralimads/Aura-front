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
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if viewModel.unlockedBadges.isEmpty {
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
            } else {
                Text("Débloqués")
                    .font(.custom("Lexend-Bold", size: 22))
                    .bold()
                    .padding(.horizontal)
                
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 120), spacing: 5)],
                    spacing: 15
                ) {
                    ForEach(viewModel.unlockedBadges) { badge in
                        Button {
                            selectedBadge = badge
                            isShowingBadgeDetails = true
                        } label: {
                            VStack(spacing: 8) {
                                if let url = viewModel.getUnlockBadgeImageURL(
                                    badge.image
                                ) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                
                                Text(badge.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(width: 120)
                                    .fixedSize(
                                        horizontal: true,
                                        vertical: false
                                    )
                            }
                            .frame(width: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                Text("À Débloquer")
                    .font(.custom("Lexend-Bold", size: 22))
                    .bold()
                    .padding(.horizontal)
                
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 120), spacing: 5)],
                    spacing: 15
                ) {
                    ForEach(viewModel.lockedBadges) { badge in
                        Button {
                            print("Badge sélectionné: \(badge.name)")
                            selectedBadge = badge
                            isShowingBadgeDetails = true
                        } label: {
                            VStack(spacing: 8) {
                                if let url = viewModel.getLockBadgeImageURL(
                                    badge.image
                                ) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                                
                                Text(badge.name)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .frame(width: 120)
                                    .fixedSize(
                                        horizontal: true,
                                        vertical: false
                                    )
                            }
                            .frame(width: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            
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
                    isLocked: viewModel.lockedBadges
                        .contains { $0.id == badge.id }
                )
                .padding(.horizontal, 30)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer(minLength: 20)
            }
            .background(Color.white)
            .presentationDetents([.medium])
        }
    }
}


#Preview {
    BadgeView(viewModel: BadgeViewModel.preview())
}
