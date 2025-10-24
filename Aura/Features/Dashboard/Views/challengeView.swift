//
//  challengeView.swift
//  Aura
//
//  Created by alize suchon on 17/10/2025.
//

import SwiftUI

struct challengeView: View {
    var body: some View {
        ZStack (alignment: .topLeading){
            //FOND
            Rectangle()
                .foregroundColor(.violet)
                .cornerRadius(25)
                .frame(maxWidth: .infinity, maxHeight: 315)
            
            VStack (alignment: .leading){
                Text("Challenge du mois")
                    .font(.custom("Lexend-Medium", size: 24))
                    .foregroundColor(.white)
                    .padding(.bottom, 2)
                Text("Effectue 3 méditations")
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .padding(.bottom, 13)
                Text("1/3")
                    .foregroundColor(.white)
                    .font(.custom("Lexend-Medium", size: 17))
                    .frame(width: 60, height: 35)
                    .background(.black.opacity(0.3))
                    .cornerRadius(25)
                    .padding(.bottom, 31)
                
                // Mettre forEach ici plus tard
                //TACHE
                ZStack(alignment: .leading){
                    Rectangle()
                        .frame( height: 35)
                        .foregroundColor(.black.opacity(0.3))
                        .cornerRadius(25)
                    //POINT + TEXTE
                    HStack(spacing: 20){
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.black.opacity(0.2))
                        Text("L’art de la présence en mouvement")
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                    }
                    .padding(.horizontal, 6)
                }
            }
            .padding(25)
                Image("challenge")
                    .resizable()
                    .frame(width: 157, height: 112)
                    .offset(x: 195, y: 50)
            
        }
       // .padding(.horizontal, 17)
    }
}

#Preview {
    challengeView()
}
