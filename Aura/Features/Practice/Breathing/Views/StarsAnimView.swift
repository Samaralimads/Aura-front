//
//  StarsAnimView.swift
//  Aura
//
//  Created by alize suchon on 09/10/2025.
//

import SwiftUI

struct StarsAnimView: View {
    
    //Remplissage du tableau d'étoiles random
    @State private var stars: [Star] = (0..<70).map { _ in
        Star(
            scale: 4,
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
            opacity: Double.random(in : 0.0...1.0)
        )
    }
    
    @State private var shootingStar = ShootingStar(
        x: -100,
        y: -100,
        length: 0
    )
    
    var body: some View {
        ZStack{
            LinearGradient(
                colors: [Color.nuitF, Color.nuitC],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // MARK: SHOOTING STARS
            
            Rectangle()
                .fill(LinearGradient(
                    colors: [Color.moon.opacity(0.01), Color.moon.opacity(1.0)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: shootingStar.length, height: 3)
                .rotationEffect(.degrees(45))
                .position(x: shootingStar.x, y: shootingStar.y)
                .onAppear { animateShootingStar() }
            
            // MARK: STARS
            ForEach(stars) { star in
                Circle()
                    .fill(Color.moon)
                    .frame(width: star.scale, height: star.scale)
                    .position(x: star.x, y: star.y)
                    .opacity(star.opacity)
            }
            //Animation continue etoiles scintillantes
            .onAppear {
                for i in 0..<stars.count {
                    
                    withAnimation(.easeInOut(duration: Double.random(in: 1...3)).repeatForever(autoreverses: true)) {
                        stars[i].opacity = CGFloat.random(in: 0...1)
                        stars[i].scale = CGFloat.random(in: 3...6)
                    }
                }
            }
            
        }
    }
    
    //MARK: - SHOOTING STAR ANIM FUNCTION
    func animateShootingStar() {
        let screen = UIScreen.main.bounds
        
        // Position de départ aléatoire (en haut à gauche de l’écran)
        let startX = CGFloat.random(in: -10...screen.width / 2)
        let startY = CGFloat.random(in: -100...screen.height / 2)
        // Position arrivée (plus bas et plus à droite)
        let endX = startX + 400
        let endY = startY + 400
        
        shootingStar.x = startX
        shootingStar.y = startY
        shootingStar.length = CGFloat.random(in: 60...120)
        
        withAnimation(.easeOut(duration: 3)) {
            shootingStar.x = endX
            shootingStar.y = endY
            shootingStar.length = 0
        }
        
        // délai aléatoire
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3...6)) {
            animateShootingStar()
        }
    }
}

#Preview {
    StarsAnimView()
}
