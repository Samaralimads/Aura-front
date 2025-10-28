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
    let reasons: [ReasonModel]
    let sleeps: [SleepModel]
    
    private var moodColor: Color {
        MoodColors.color(forName: day.mood, in: moods)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(day.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // MARK: - Header
            HStack(alignment: .center, spacing: 12) {
                if let url = iconURL {
                    AsyncImage(url: url) { img in
                        img.resizable()
                            .scaledToFit()
                            .frame(height: 67)
                    } placeholder: {
                        ProgressView()
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
            
            // MARK: - Reason & Sleep
            HStack(spacing: 16) {
                if day.reason != "Void" {
                    if let reason = reasons.first(where: {
                        $0.name == day.reason
                    }) {
                        Label {
                            Text(day.reason)
                                .font(.system(size: 17))
                            
                        } icon: {
                            Image("\(reason.image)-fill")
                                .renderingMode(.template)
                                .foregroundStyle(moodColor)
                        }
                        
                    } else {
                        Label(day.reason, systemImage: "questionmark.circle")
                    }
                }
                
                if day.sleep != "Void" {
                    if let sleep = sleeps.first(where: {
                        $0.name == day.sleep
                    }) {
                        Label {
                            Text(day.sleep)
                                .font(.system(size: 17))
                        } icon: {
                            Image("\(sleep.image)-fill")
                                .renderingMode(.template)
                                .foregroundStyle(moodColor)
                        }
                    } else {
                        Label(day.sleep, systemImage: "moon.zzz")
                    }
                }
            }
            
            // MARK: - Journal
            if day.journal.lowercased() != "void" &&
                !day.journal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(day.journal)
                    .font(.system(size: 17))
                    .padding(.top, 4)
            } else {
                Text("Vous n’avez rien ajouté pour cette journée.")
                    .font(.system(size: 17))
            }
            
            // MARK: - Edit Button
            if isToday {
                Button {
                    // TODO: navigate to edit screen
                } label: {
                    Text("Modifier")
                        .font(.custom("Lexend-medium", size: 17))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(moodColor)
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                }
                .padding(.top, 4)
            }
            Spacer(minLength: 0)
        }
        .padding(30)
    }
}




