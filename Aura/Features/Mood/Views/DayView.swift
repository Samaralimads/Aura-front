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
                        showDetail = true
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
                            await vm.fetchDays()
                        }
                    }
            .sheet(isPresented: $showDetail) {
                if let date = selectedDate, let day = vm.day(for: date) {
                    DayDetailSheet(day: day, iconURL: vm.moodIconURL(for: day))
                        .presentationDetents([.fraction(0.35), .medium])
                }
            }
            .navigationDestination(isPresented: $goToMood) {
                MoodView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DayView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiJDQ0Y0RjRCMy1FNkU2LTRBOEYtQTM4Mi0zRDM1MDc1RTM4NTciLCJleHBpcmF0aW9uIjoxNzYxMDMzNTYzLjA1NjYwNDksInN1YmplY3QiOiJDQ0Y0RjRCMy1FNkU2LTRBOEYtQTM4Mi0zRDM1MDc1RTM4NTcifQ.ykK-tIAjo_CL-MzyLm7nsC6I4AZX5oG5Wbh5pTjhadY")
    }
}
