//
//  FloatingDots.swift
//  Aura
//
//  Created by Samara Lima da Silva on 03/10/2025.
//

import SwiftUI

struct FloatingDots: View {
    let base: Color
    let count: Int
    @State private var toggles: [Bool]
    
    init(base: Color, count: Int) {
        self.base = base
        self.count = count
        self._toggles = State(initialValue: Array(repeating: false, count: count))
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<count, id: \.self) { i in
                    let size = CGFloat(Int.random(in: 5...10))
                    let x = CGFloat.random(in: 0...500)
                    let y = CGFloat.random(in: 300...600)
                    
                    Circle()
                        .fill(base)
                        .frame(width: size, height: size)
                        .position(x: x, y: y)
                        .offset(y: toggles[i] ? -10 : 10)
                        .animation(
                            .easeInOut(duration: Double.random(in: 9.0...10.0))
                            .repeatForever(autoreverses: true)
                            .delay(Double(i) * 0.05),
                            value: toggles[i]
                        )
                }
            }
            .onAppear {
                for i in 0..<count {
                    toggles[i].toggle()
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .blendMode(.plusLighter)
    }
}

#Preview {
    FloatingDots(base: .black, count: 20)
}
