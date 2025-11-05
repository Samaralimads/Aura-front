//
//  DayView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 02/10/2025.
//

import SwiftUI

struct DayView: View {
    @Environment(AppState.self) private var appState
    
    @State private var vm = DayViewModel()
    @State private var moodVM = MoodViewModel()
    @State private var month = Date()
    @State private var selectedDate: Date?
    @State private var detailDay: DayModel?
    
    var token: String? = nil
    var moods: [MoodModel]? = nil
    
    private var effectiveToken: String? { token ?? appState.token }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 30) {
                Text("Suivi d’humeur")
                    .font(.custom("Lexend-medium", size: 28))
                    .padding(.top, 10)
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
                    onAddTodayMood: {  appState.humeurPath.append(HumeurRoute.mood) }
                )
                
                
                //MARK: - Mood % view
                MoodPercentageView(
                    month: month,
                    days: vm.days,
                    moods: vm.moods
                )                
            }
            .navigationBarBackButtonHidden(true)
            .padding(16)
            .task(id: effectiveToken) {
                guard let token = effectiveToken?.trimmingCharacters(in: .whitespacesAndNewlines),
                      !token.isEmpty else {
                    print("No token available yet — skipping fetch")
                    return
                }
                print("Token found:", token.prefix(12))
                vm.authToken = token
                // moods
                if let provided = moods {
                    vm.useMoods(provided)
                } else {
                    await moodVM.fetchMoods()
                    vm.useMoods(moodVM.moods)
                }

                // protected data
                await vm.fetchReasons()
                await vm.fetchSleeps()
                await vm.fetchDays()
            }
            .task(id: appState.refreshDaysTrigger) {
                       guard let token = effectiveToken?.trimmingCharacters(in: .whitespacesAndNewlines),
                             !token.isEmpty else { return }
                       vm.authToken = token
                       await vm.fetchDays()
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
                       .presentationBackground(.white)
                   }
               }
           }

#Preview {
    NavigationStack {
        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWJqZWN0IjoiNkEyMkIxMkQtOTExNi00NzhGLUE1NTYtRUMzQkVCQkI4MTJCIiwidXNlcklEIjoiNkEyMkIxMkQtOTExNi00NzhGLUE1NTYtRUMzQkVCQkI4MTJCIiwiZXhwaXJhdGlvbiI6MTc2MjUxMTI4MS42MjkwOTh9.dFit2du8-oB9ja6haIKDM2-Jjm2p03xuUFEdnFZ1eBE")
            .environment(AppState())
    }
}
