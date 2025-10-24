//
//  BadgeDetailsView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import SwiftUI

struct BadgeDetailsView: View {
    let badge: UserProfileResponse.Badge
    let isLocked: Bool
    @State private var viewModel: BadgeDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(badge: UserProfileResponse.Badge, isLocked: Bool) {
        self.badge = badge
        self.isLocked = isLocked
        _viewModel = State(initialValue: BadgeDetailsViewModel(badge: badge, isLocked: isLocked))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Détails du badge")
                .font(.custom("Lexend-Medium", size: 18))

            if let url = viewModel.getBadgeFullPage(badge.image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 150, height: 150)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            Text(badge.name)
                .font(.title2)
                .bold()
            
            Text(badge.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
    }
}


#Preview {
    let testBadge = UserProfileResponse.Badge(
        id: "1",
        name: "Test Badge",
        description: "This is a test badge description",
        image: "http://127.0.0.1:8080/badges/leaf.png"
    )
    return NavigationStack {
        BadgeDetailsView(badge: testBadge, isLocked: true)
    }
}
