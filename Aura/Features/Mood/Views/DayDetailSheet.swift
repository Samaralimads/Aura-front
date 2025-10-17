//
//  DayDetailSheet.swift
//  Aura
//
//  Created by Samara Lima da Silva on 11/10/2025.
//

import SwiftUI

struct DayDetailSheet: View {
    let day: DayModel
    let iconURL: URL?
    let moods: [MoodModel]          

    private var moodColor: Color {
        MoodColors.color(forName: day.mood, in: moods)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 12) {
                if let url = iconURL {
                    AsyncImage(url: url) { img in
                        img.resizable().scaledToFit().frame(height: 67)
                    } placeholder: {
                        Circle().stroke(style: StrokeStyle(lineWidth: 2, dash: [4]))
                            .frame(height: 67)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(day.date.formatted(.dateTime.weekday(.wide).day().month(.wide)))
                        .font(.system(size: 17, weight: .bold))
                        .padding(.bottom, 8)

                    if day.emotion.lowercased() != "void" {
                        Text(day.emotion)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundStyle(moodColor)
                    }
                }
                Spacer()
            }

            HStack(spacing: 16) {
                if day.reason.lowercased() != "void" {
                    Label(day.reason, systemImage: "location.circle")
                }
                if day.sleep.lowercased() != "void" {
                    Label(day.sleep, systemImage: "moon.zzz")
                }
            }
            .font(.subheadline)
            .foregroundStyle(moodColor)

            if day.journal.lowercased() != "void" && !day.journal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(day.journal)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            } else {
                Text("Vous n’avez rien ajouté pour cette journée.")
            }

            Button {
                // TODO: navigate to edit screen
            } label: {
                Text("Modifier")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(moodColor)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .padding(30)
    }
}



