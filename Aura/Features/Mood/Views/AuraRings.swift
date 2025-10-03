//
//  AuraRings.swift
//  Aura
//
//  Created by Samara Lima da Silva on 03/10/2025.
//

import SwiftUI

struct AuraRings: View {
    let base: Color
    @State private var phase = false

    var body: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .stroke(base.opacity(0.35 - Double(i) * 0.08), lineWidth: 2)
                    .scaleEffect(phase ? (1.15 + CGFloat(i) * 0.06) : (0.85 + CGFloat(i) * 0.06))
                    .opacity(phase ? 0.25 : 0.6 - Double(i) * 0.1)
                    .animation(
                        .easeInOut(duration: 3.2)
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.35),
                        value: phase
                    )
            }
        }
        .onAppear { phase = true }
    }
}

#Preview {
    AuraRings(base: .pink)
}
