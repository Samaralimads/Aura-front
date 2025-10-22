//
//  BadgeDetailsViewModel.swift
//  Aura
//
//  Created by Mehdi Legoullon on 20/10/2025.
//

import SwiftUI
import Observation


@Observable
class BadgeDetailsViewModel {
    let badge: UserProfileResponse.Badge
    var image: UIImage?
    var isLoading = false
    
    init(badge: UserProfileResponse.Badge) {
        self.badge = badge
    }
}
