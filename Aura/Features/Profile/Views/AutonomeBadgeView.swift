//
//  AutonomeBadgeView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 28/10/2025.
//

import SwiftUI

struct AutonomeBadge: View {
    let badge: UserProfileResponse.Badge
    let isLocked: Bool
    @State private var styleMapper = BadgeStyleMapper()
    
    private var style: BadgeStyle {
        styleMapper.style(for: badge.name)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(isLocked ? Color.gray.opacity(0.5) : style.backgroundColor)
                .frame(width: 110, height: 110)
            
            VStack(spacing: 6) {
                Circle()
                    .fill(isLocked ? Color.gray.opacity(0.7) : style.iconBackgroundColor)
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(isLocked ? "lock" : style.iconName)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 27, height: 27)
                            .foregroundColor(.white)
                    )
                    .padding(.top, 8)
                
                Text(badge.name)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(.horizontal, 4)
                
                Spacer()
            }
            .frame(height: 90)
        }
        .frame(width: 110, height: 110)
    }
}

extension AutonomeBadge {
    init(badge: UserProfileResponse.Badge) {
        self.init(badge: badge, isLocked: false)
    }
}


#Preview {
    HStack(spacing: 20) {
        AutonomeBadge(badge: UserProfileResponse.Badge(
            id: "1",
            name: "First Meditation",
            description: "Completed your first meditation session.",
            image: "/Badges/leaf.png"
        ))
        
        AutonomeBadge(
            badge: UserProfileResponse.Badge(
                id: "2",
                name: "Advanced Sleep",
                description: "Advanced meditation",
                image: "/Badges/lock.png"
            ),
            isLocked: true
        )
    }
    .padding()
}
