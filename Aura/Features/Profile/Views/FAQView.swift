//
//  FAQView.swift
//  Aura
//
//  Created by Mehdi Legoullon on 22/10/2025.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                Text("Questions Fréquentes")
                    .font(.custom("Lexend-SemiBold", size: 24))
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comment utiliser AURA pour la méditation ?")
                        .font(.custom("Lexend-Medium", size: 18))
                    Text(
                        "Ouvrez l’onglet Méditation, choisissez une session guidée, et laissez-vous guider par la voix. Vous pouvez personnaliser la durée dans les paramètres."
                    )
                    .font(.custom("Lexend-Light", size: 16))
                    .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comment suivre mon humeur dans AURA ?")
                        .font(.custom("Lexend-Medium", size: 18))
                    Text(
                        "Dans l’onglet Humeur, sélectionnez votre état émotionnel du jour et notez votre ressenti. Un historique est disponible pour suivre votre évolution."
                    )
                    .font(.custom("Lexend-Light", size: 16))
                    .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Puis-je utiliser AURA sans connexion Internet ?")
                        .font(.custom("Lexend-Medium", size: 18))
                    Text(
                        "Oui, les méditations et défis téléchargés sont accessibles hors ligne. Connectez-vous pour accéder à toutes les fonctionnalités."
                    )
                    .font(.custom("Lexend-Light", size: 16))
                    .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comment personnaliser mes rappels ?")
                        .font(.custom("Lexend-Medium", size: 18))
                    Text(
                        "Allez dans Réglages > Rappels pour configurer les notifications (méditation, hydratation, etc.)."
                    )
                    .font(.custom("Lexend-Light", size: 16))
                    .foregroundColor(.gray)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Mes données sont-elles sécurisées ?")
                        .font(.custom("Lexend-Medium", size: 18))
                    Text(
                        "Oui, toutes vos données sont chiffrées et stockées localement. Aucune information personnelle n’est partagée sans votre consentement."
                    )
                    .font(.custom("Lexend-Light", size: 16))
                    .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("FAQs")
                    .font(.custom("Lexend-Medium", size: 27))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    FAQView()
}
