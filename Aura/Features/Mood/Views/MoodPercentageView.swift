//
//  MoodPercentageView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 20/10/2025.
//

import SwiftUI

struct MoodPercentageView: View {
    let month: Date
    let days: [DayModel]
    let moods: [MoodModel]
    let baseURL: URL? = URL(string: "http://127.0.0.1:8080")

    @State private var selection = 0

    // MARK: - Derived data
    private var distribution: [Slice] {
        let cal = Calendar.current
        let monthDays = days.filter { cal.isDate($0.date, equalTo: month, toGranularity: .month) }

        // Count moods (skip "void")
        let counts = monthDays.reduce(into: [String:Int]()) { acc, d in
            let key = normalize(d.mood)
            guard key != "void" else { return }
            acc[key, default: 0] += 1
        }
        let total = counts.values.reduce(0, +)
        guard total > 0 else { return [] }

        // Join with catalog
        let byName = Dictionary(uniqueKeysWithValues: moods.map { (normalize($0.name), $0) })

        // Build slices and sort DESC (largest → smallest)
        return counts.compactMap { (name, count) in
            guard let model = byName[name] else { return nil }
            return Slice(mood: model, percentage: Double(count) / Double(total))
        }
        .sorted { $0.percentage > $1.percentage }
    }

    var body: some View {
        if distribution.isEmpty {
            EmptyState()
        } else {
            TabView(selection: $selection) {
                ForEach(distribution.indices, id: \.self) { idx in
                    HighlightCard(slice: distribution[idx], baseURL: baseURL)
                        .tag(idx)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: distribution.count > 1 ? .always : .never))
            .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        }
    }

    // MARK: - Models & helpers
    struct Slice {
        let mood: MoodModel
        let percentage: Double
    }
    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}

// MARK: - Card
private struct HighlightCard: View {
    let slice: MoodPercentageView.Slice
    let baseURL: URL?

    private var bgColor: Color {
        MoodColors.fromAsset(name: slice.mood.color).opacity(0.75)
    }
    private var percentText: String {
        "\(Int(round(slice.percentage * 100))) %"
    }
    private var moodImageURL: URL? {
        guard let baseURL else { return nil }
        return baseURL.appending(path: "mood").appending(path: slice.mood.image)
    }

    var body: some View {
        ZStack {
                // background
                bgColor
                
                // White circles
                ZStack {
                    Image("Vector24")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 314)
                        .padding(.bottom, 60)
                    Image("Vector25")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 340)
                        .padding(.bottom, 60)
                    Image("Vector26")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 270)
                        .padding(.bottom, 60)
                        .opacity(0.5)
                }
                VStack {
                    // Image
                    if let url = moodImageURL {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 139, height: 136)
                                .padding(.top, 10)
                        } placeholder: {
                            ProgressView()
                                .frame(height: 136)
                        }
                    }

                    // Text
                    Text(percentText)
                        .font(.system(size: 50, weight: .bold))

                    HStack {
                        Text(slice.mood.name)
                            .font(.system(size: 17, weight: .bold))
                        Text("ce mois-ci")
                            .font(.system(size: 17))
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 40)
                .padding(.top, 15)

            }
            .frame(minHeight: 260)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 30))
        }
}

          // MARK: - Empty State
private struct EmptyState: View {
    var body: some View {
        ZStack {
            Color(.bleu)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                
            // MARK:   - White circles
                ZStack {
                    Image("Vector24")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 314)
                        .padding(.bottom, 60)
                    Image("Vector25")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 340)
                        .padding(.bottom, 60)
                    Image("Vector26")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 270)
                        .padding(.bottom, 60)
                        .opacity(0.5)
                }

            VStack{
                
               // Image
                    Image(.noMood)
                            .resizable()
                                .scaledToFit()
                                .frame(width: 139, height: 136)
                      

                    // Text
                    
                    Text("Aucune humeur enregistrée \n ce mois-ci")
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
            }
                }
        .frame(minHeight: 260)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 30))
            }
        }

