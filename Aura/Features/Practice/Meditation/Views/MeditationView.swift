//
//  MeditationView.swift
//  Aura
//
//  Created by Chabane on 20/10/2025.
//

import SwiftUI

struct MeditationView: View {
    @State private var viewModel = MeditationViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    //  Boucle sur les thème de méditations ( je les ai ajouté manuellement dans dans le MeditationViewModel)
                    ForEach(viewModel.themeOrder, id: \.self) { theme in
                        if let meditations = viewModel.groupedByTheme()[theme] {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text(theme)
                                        .font(.custom("Lexend-Medium", size: 22))
                                    Spacer()
                                    NavigationLink("Voir tout") {
                                        MeditationListByThemeView(theme: theme, meditations: meditations)
                                    }
                                    .foregroundStyle(Color.black)
                                    .underline()
                                }
                                .padding(.horizontal)

                                // Slider horizontal
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 30) {
                                        ForEach(meditations) { meditation in
                                            NavigationLink {
                                                MeditationDetailView(meditation: meditation)
                                            } label: {
                                                MeditationCardView(meditation: meditation)
                                                    .frame(width: 160)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MeditationView()
}
