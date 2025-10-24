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
        _viewModel = State(
            initialValue: BadgeDetailsViewModel(
                badge: badge,
                isLocked: isLocked
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 24)
                .padding(.top, 16)
            }
            
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
                            .frame(width: 150, height: 150)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
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
        .navigationTitle(badge.name)
        .navigationBarTitleDisplayMode(.inline)
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
