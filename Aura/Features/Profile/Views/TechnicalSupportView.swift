//
//  TechnicalSupportView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//

import SwiftUI

struct TechnicalSupportView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 12) {
                    Text("Comment nous contacter")
                        .font(.custom("Lexend-SemiBold", size: 20))
                    
                    HStack(spacing: 8) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.blue)
                        Text("support@aura.com")
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.blue)
                        Text("+33 1 23 45 67 89")
                            .foregroundColor(.blue)
                    }
                    
                    HStack(spacing: 8) {
                        Image(systemName: "house.fill")
                            .foregroundColor(.blue)
                        Text("123 Rue du Bien-être, Paris")
                            .foregroundColor(.blue)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Horaires d'ouverture")
                        .font(.custom("Lexend-SemiBold", size: 20))
                    
                    Text("Lundi - Vendredi: 9h - 18h")
                    Text("Samedi: 10h - 14h")
                    Text("Dimanche: Fermé")
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Informations utiles")
                        .font(.custom("Lexend-SemiBold", size: 20))
                    
                    Text("• Réponse sous 24h (jours ouvrés)")
                    Text("• Support en français et anglais")
                    Text("• FAQ disponible dans l'application")
                }
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Support technique")
                    .font(.custom("Lexend-Medium", size: 27))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    TechnicalSupportView()
}
