//
//  DayView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 02/10/2025.
//

import SwiftUI

struct DayView: View {
    @State private var viewModel = DayViewModel()
    
    let token: String? 
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Votre calendrier")
                .font(.title2)
                .padding(.bottom, 8)
            
            if viewModel.days.isEmpty {
                Text("Aucun enregistrement")
                    .foregroundStyle(.secondary)
            } else {
                List(viewModel.days) { day in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(day.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.headline)
                        Text("\(day.mood) · \(day.emotion) · \(day.sleep) · \(day.reason)")
                            .font(.subheadline)
                        if !day.journal.isEmpty && day.journal.lowercased() != "void" {
                            Text(day.journal)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
        .padding()
        .task {
            viewModel.authToken = token
            await viewModel.fetchDays()
        }
    }
}

#Preview {
    NavigationStack {
        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHBpcmF0aW9uIjoxNzU5NTA0NDc5LjU4NTk2LCJpZCI6IjZBMjJCMTJELTkxMTYtNDc4Ri1BNTU2LUVDM0JFQkJCODEyQiJ9.8KiOHg7IShtj-Db0QTsODPZXFSeCWGV4AbTdGbvfihc")
    }
}
