//
//  SettingView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack {
            Image("perso-violet")
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 112)
            
            Text("Modifier mon avatar")
                .font(.custom("Lexend-Regular", size: 17))
                .padding()
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Réglages")
                    .font(.custom("Lexend-Medium", size: 27))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    SettingView()
}
