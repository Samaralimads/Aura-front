//
//  MoodColors.swift
//  Aura
//
//  Created by Samara Lima da Silva on 17/10/2025.
//

import SwiftUI

enum MoodColors {
    static func color(forID id: UUID?, in moods: [MoodModel]) -> Color {
        guard
            let id,
            let mood = moods.first(where: { $0.id == id })
        else { return fallbackColor }
        return fromAsset(name: mood.color)
    }
    
    static func color(forName name: String?, in moods: [MoodModel]) -> Color {
        guard
            let name,
            let mood = moods.first(where: {
                $0.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                == name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            })
        else { return fallbackColor }
        return fromAsset(name: mood.color)
    }
    
    static func fromAsset(name: String?) -> Color {
        guard let name, !name.isEmpty else { return fallbackColor }
        return Color(name)
    }
    
    private static var fallbackColor: Color {
        Color.gray
    }
}
