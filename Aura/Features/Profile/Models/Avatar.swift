//
//  Avatar.swift
//  Aura
//
//  Created by Mehdi Legoullon on 24/10/2025.
//

import Foundation

struct AvatarsListResponse: Codable {
    let avatars: [Avatar]
}

struct Avatar: Codable, Identifiable {
    let id: Int
    var url: String
}
