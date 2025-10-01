//
//  CategorySliderView.swift
//  Aura
//
//  Created by Chabane on 01/10/2025.
//

import SwiftUI

struct CategorySliderView: View {
    let title: String
    let meditations: [Meditation]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                .font(.custom("Lexend-Medium", size: 22, relativeTo: .headline))
                Spacer()
                NavigationLink("Voir tout") {
                    MeditationListView(title: title, meditations: meditations)
                }
                .foregroundStyle(Color.black)
                .underline()

            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(meditations) { meditation in
                        NavigationLink {
                            MeditationDetailView(meditation: meditation)
                        } label: {
                            MeditationCardView(meditation: meditation)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        CategorySliderView(
            title: "Nouveau",
            meditations: [
                Meditation(id: UUID(), title: "Méditation 1", duration: 30, theme: .nouveau, image: "med1", audio: "audio1"),
                Meditation(id: UUID(), title: "Méditation 2", duration: 20, theme: .nouveau, image: "med2", audio: "audio2")
            ]
        )
    }
}

