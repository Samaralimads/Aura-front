//
//  starsModel.swift
//  Aura
//
//  Created by alize suchon on 09/10/2025.
//

import SwiftUI

struct Star: Identifiable  {
    let id = UUID()
    var scale: CGFloat
    var x: CGFloat
    var y: CGFloat
    var opacity: Double
}

struct ShootingStar: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var length: CGFloat
}

