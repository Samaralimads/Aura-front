//
//  BadgeView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 17/10/2025.
//

import SwiftUI

struct BadgeView: View {
    @State private var viewModel = BadgeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Badges débloqués")
                    .font(.custom("Lexend-Bold", size: 22))
                    .bold()
                    .padding(.horizontal)
                    
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 100))],
                    spacing: 16
                ) {
                    ForEach(viewModel.unlockedBadges) { badge in
                        VStack {
                            if let url = viewModel.getBadgeImageURL(
                                badge.image
                            ) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 80, height: 80)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                                
                            Text(badge.name)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .frame(width: 100)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            .navigationTitle("Mes Badges")
            .task {
                await viewModel.fetchUserBadges()
            }
        }
    }
}


#Preview {
    BadgeView()
}
