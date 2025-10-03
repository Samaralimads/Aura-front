//
//  SunAnimationView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct SunAnimationView: View {
    var body: some View {
        ZStack {
           
            LinearGradient(
                colors: [Color.naranja, Color.orangeClair],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            //NUAGE 1
            Image("nuage")
                .resizable()
                .frame(width: 141, height: 58)
                .offset(x: -150, y: -330)
            
            //SUN
            Circle()
                .fill(Color.jaune)
                .frame(width: 140, height: 140)
                .offset(x: 10, y: -150)
            Circle()
                .fill(Color.jaune)
                .opacity(0.5)
                .frame(width: 200, height: 200)
                .offset(x: 10, y: -150)
            
            //NUAGE 2
            Image("nuage")
                .resizable()
                .frame(width:204 , height: 84)
                .offset(x: 100, y: -170)
            
            //NUAGE 3
            Image("nuage")
                .resizable()
                .frame(width: 249 , height: 101)
                .offset(x: -200, y: 60)
            
                .offset(x: 100, y: -10)
            //NUAGE BAS
            Image("nuageBas")
                .resizable()
                .frame(width: 441, height: 166)
                .offset(x: 0, y: 360)
        }
    }
}

#Preview {
    SunAnimationView()
}
