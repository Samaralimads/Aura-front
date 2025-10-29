//
//  BadgeStyleMapper.swift
//  Aura
//
//  Created by Mehdi Legoullon on 28/10/2025.
//

import SwiftUI

struct BadgeStyle {
    let backgroundColor: Color
    let iconBackgroundColor: Color
    let iconName: String
}

class BadgeStyleMapper {

    private let styles: [String: BadgeStyle] = [
        "First Meditation": BadgeStyle(
            backgroundColor: Color("rose"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "leaf"
        ),
        "7-Day Streak": BadgeStyle(
            backgroundColor: Color("jaune"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "flower"
        ),
        "Sleep Challenge": BadgeStyle(
            backgroundColor: Color("vert"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "moon"
        ),
        "Breathing Master": BadgeStyle(
            backgroundColor: Color("vert"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "wind"
        ),
        "Mental Challenge": BadgeStyle(
            backgroundColor: Color("violet"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "mental"
        ),
        "Lotus Challenge": BadgeStyle(
            backgroundColor: Color("naranja"),
            iconBackgroundColor: Color("iconBackground").opacity(0.3),
            iconName: "flower-lotus"
        )
    ]
    
    func style(for badgeName: String) -> BadgeStyle {
        let defaultStyle = BadgeStyle(
            backgroundColor: Color("rose"),
            iconBackgroundColor: Color("violet-clair").opacity(0.3),
            iconName: "leaf"
        )
        
        return styles[badgeName] ?? defaultStyle
    }
}
