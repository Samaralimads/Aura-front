//
//  DayView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 02/10/2025.
//

import SwiftUI

struct DayView: View {
    @State private var vm = DayViewModel()
    @State private var moodVM = MoodViewModel()
    @State private var month = Date()
    @State private var selectedDate: Date?
    @State private var showDetail = false
    @State private var goToMood = false
    @State private var detailDay: DayModel?

    var token: String? = nil
    var moods: [MoodModel]? = nil

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Suivi d’humeur")
                    .font(.custom("Lexend-medium", size: 28))

                CalendarMonth(
                    month: $month,
                    dayFor: { date in vm.day(for: date) },
                    moodIconURL: { day in vm.moodIconURL(for: day) },
                    onSelect: { date in
                        selectedDate = date
                        let cal = Calendar.current
                        let today = cal.startOfDay(for: Date())
                        let dayStart = cal.startOfDay(for: date)

                        if let d = vm.day(for: date),
                           dayStart <= today,
                           !d.mood.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                           d.mood != "Void" {
                            detailDay = d
                                } else {
                                    detailDay = nil
                                }
                            },
                    onAddTodayMood: { goToMood = true }
                )

                Spacer(minLength: 0)
            }
            .padding()
            .task(id: token) {
                        vm.authToken = token
                        if let provided = moods {
                            vm.useMoods(provided)
                        } else {
                            await moodVM.fetchMoods()
                            vm.useMoods(moodVM.moods)
                        }
                        if token != nil {
                            await vm.fetchReasons()
                            await vm.fetchSleeps()
                            await vm.fetchDays()
                        }
                    }
            .sheet(item: $detailDay) { day in
                DayDetailSheet(
                    day: day,
                    iconURL: vm.moodIconURL(for: day),
                    moods: vm.moods,
                    reasons: vm.reasons,  
                    sleeps: vm.sleeps
                    
                )
                .presentationDetents([.fraction(0.35), .medium])
            }
            .navigationDestination(isPresented: $goToMood) {
                MoodView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiI2QTIyQjEyRC05MTE2LTQ3OEYtQTU1Ni1FQzNCRUJCQjgxMkIiLCJzdWJqZWN0IjoiNkEyMkIxMkQtOTExNi00NzhGLUE1NTYtRUMzQkVCQkI4MTJCIiwiZXhwaXJhdGlvbiI6MTc2MTI5NTkwMS45NDcxNX0.jQhxy7my2Q3sSkR8qrAXCmyhMOeZ3NjjWFzOlFFD-vQ")
    }
}
