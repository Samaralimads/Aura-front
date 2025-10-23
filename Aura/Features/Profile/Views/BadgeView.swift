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
            // Section des badges débloqués
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
                            print("Badge sélectionné: \(badge.name)")
                            selectedBadge = badge
                            isShowingBadgeDetails = true
                        } label: {
                            VStack(spacing: 8) {
                                if let url = viewModel.getUnlockBadgeImageURL(badge.image) {
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
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            
            // Section des badges à débloquer
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
                                if let url = viewModel.getLockBadgeImageURL(badge.image) {
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
                                    .fixedSize(horizontal: true, vertical: false)
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
        .navigationTitle("Mes Badges")
        .task {
            await viewModel.fetchUserBadges()
        }
        .fullScreenCover(item: $selectedBadge) { badge in
            NavigationStack {
                BadgeDetailsView(
                    badge: badge,
                    isLocked: viewModel.lockedBadges.contains(where: { $0.id == badge.id })
                )
                .navigationTitle(badge.name)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    BadgeView(viewModel: BadgeViewModel.preview())
}
