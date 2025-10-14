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
                    Text(formattedLongDate(day.date))
                        .font(.system(size: 17, weight: .bold))
                    if day.emotion != "Void" {
                        Text(day.emotion)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.yellow)
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
            .foregroundStyle(.primary)

            if day.journal != "Void" {
                Text(day.journal)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            } else {
               Text("Vous n’avez rien ajouté pour cette journée.")
            }

            Button {
                // TODO: navigate to edit screen and only for the current day
            } label: {
                Text("Modifier")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(.yellow.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
            }
            .padding(.top, 4)

            Spacer(minLength: 0)
        }
        .padding(16)
    }

    private func formattedLongDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "fr_FR")
        f.dateFormat = "EEEE, d MMMM"
        return f.string(from: date)
    }
}

