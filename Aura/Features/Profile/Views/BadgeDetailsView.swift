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
    @Environment(\.dismiss) private var dismiss
    private let styleMapper = BadgeStyleMapper()
    
    private var style: BadgeStyle {
        styleMapper.style(for: badge.name)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Détails du badge")
                .font(.custom("Lexend-Medium", size: 22))
                .padding(.horizontal, 20)
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(isLocked ? Color.gray.opacity(0.5) : style.backgroundColor)
                    .frame(width: 180, height: 180)
                
                VStack(spacing: 12) {
                    Circle()
                        .fill(isLocked ? Color.gray.opacity(0.7) : style.iconBackgroundColor)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(isLocked ? "lock" : style.iconName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        )
                        .padding(.top, 16)
                    
                    Text(badge.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isLocked ? .gray : .white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                        .padding(.horizontal, 8)
                    
                    Spacer()
                }
                .frame(height: 150)
            }
            
            Text(badge.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            
            Spacer()
        }
        .padding(.bottom, 120)
        .navigationTitle("Badge")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    NavigationStack {
        BadgeDetailsView(
            badge: UserProfileResponse.Badge(
                id: "1",
                name: "First Meditation",
                description: "Vous avez complété votre première séance de méditation. Félicitations !",
                image: "/Badges/leaf.png"
            ),
            isLocked: false
        )
    }
}
