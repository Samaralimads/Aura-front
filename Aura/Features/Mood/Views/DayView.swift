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
            VStack(alignment: .leading, spacing: 20) {
                Text("Suivi d’humeur")
                    .font(.custom("Lexend-medium", size: 28))
                //MARK: - Calendar view
                
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
                
                
                //MARK: - Mood % view
                MoodPercentageView(
                    month: month,
                    days: vm.days,
                    moods: vm.moods
                )
                Spacer()
                
            }
            .padding(16)
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


#Preview {
    NavigationStack {
        DayView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0IjoiQjg4OTNCNTItMzZDQy00NjA3LTk3MjQtQzcxRjNCMTQ1QzNFIiwidXNlcklEIjoiQjg4OTNCNTItMzZDQy00NjA3LTk3MjQtQzcxRjNCMTQ1QzNFIiwiZXhwaXJhdGlvbiI6MTc2MTI5MzUwNi4zNDY5ODQ5fQ.ztk4M6w7mGe2XeOX-CbUCkBbTrLJOZ23LzERMTo_09g")
    }
}
