//
//  MoonAnimationView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct MoonAnimationView: View {
    var body: some View {
        ZStack {
           
            LinearGradient(
                colors: [Color.nuitF, Color.nuitC],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        }
    }
}

#Preview {
    MoonAnimationView()
}
