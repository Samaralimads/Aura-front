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

            // Unlocked Badges Section
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
                            if let url = viewModel.getBadgeImageURL(
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
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .frame(width: 120)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
            
            // Locked Badges Section
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
                                if let url = viewModel.getBadgeImageURL(
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
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(width: 120)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                
                .padding(.vertical)
                .navigationTitle("Mes Badges")
                .task {
                    await viewModel.fetchUserBadges()
                }
                .fullScreenCover(item: $selectedBadge) { badge in
                    NavigationStack {
                        BadgeDetailsView(badge: badge)
                            .navigationTitle(badge.name)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
                
                Spacer()
            }
        }
    }
}


#Preview {
    BadgeView(viewModel: BadgeViewModel.preview())
}
