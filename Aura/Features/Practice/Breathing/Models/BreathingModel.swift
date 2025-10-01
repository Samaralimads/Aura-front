//
//  BreathingModel.swift
//  Aura
//
//  Created by alize suchon on 28/09/2025.
//

import SwiftUI

struct Breathing : Codable, Identifiable {
    var id: UUID = UUID()
    var image: String
    var title: String
    var description: String
    var inhaleD: Int
    var holdD: Int
    var exhaleD: Int
    var audio: String?
    var nbOfCycles: Int
}
