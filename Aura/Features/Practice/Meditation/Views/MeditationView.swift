//
//  MeditationView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct MeditationView: View {
    @StateObject private var viewModel = MeditationViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CategorySliderView(
                    title: "Nouveau",
                    meditations: viewModel.meditations(for: .nouveau)
                )
                CategorySliderView(
                    title: "Coup de cœur",
                    meditations: viewModel.meditations(for: .coupDeCoeur)
                )
                CategorySliderView(
                    title: "Débutants",
                    meditations: viewModel.meditations(for: .debutant)
                )
            }
            .padding()
        }
       .navigationTitle("Prêt à commencer ?") //Titre déja ajouté par Alizé dans la Vue PickerView
    }
}

#Preview {
    NavigationView {
        MeditationView()
    }
}
