//
//  ChallengeModel.swift
//  Aura
//
//  Created by alize suchon on 20/10/2025.
//

import SwiftUI

struct Challenge: Identifiable, Codable {
    var id: UUID?
    var theme: String
    var image: String
    var description: String
    var startDate: Date
    var endDate: Date
}

struct Tache: Identifiable, Codable {
    var id: UUID?
    var title: String
    var challengeID: UUID?
}
