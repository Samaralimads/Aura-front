//
//  BadgeDetailsView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import SwiftUI


struct BadgeDetailsView: View {
    let badge: UserProfileResponse.Badge
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 16)
                .padding(.top, 16)
            }
            
            if let url = URL(string: badge.image) {
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
        image: "/badges/lotus.png"
    )
    return NavigationStack {
        BadgeDetailsView(badge: testBadge)
    }
}
