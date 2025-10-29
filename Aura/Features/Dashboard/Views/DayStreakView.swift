//
//  DayStreakView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 27/10/2025.
//

import SwiftUI

struct DayStreakView: View {
    @Environment(AppState.self) private var appState
       
       @State private var vm = DayViewModel()
       @State private var moodVM = MoodViewModel()
       
       var token: String? = nil
       var moods: [MoodModel]? = nil
       
       private var effectiveToken: String? { token ?? appState.token }

       var body: some View {
           HStack(spacing: 5) {
               ForEach(currentWeekDates(), id: \.self) { date in
                   let day = vm.day(for: date)
                   let hasDay = day != nil
                   let color = hasDay
                       ? MoodColors.color(forName: day?.mood, in: vm.moods)
                       : Color.gray.opacity(0.2)
                   let textColor: Color = hasDay ? .white : .gray

                   VStack(spacing: 6) {
                       Text(dayNumber(from: date))
                           .font(.custom("Lexend-Regular", size: 20))
                           .foregroundColor(textColor)
                           .padding(.top, 8)
                       Text(dayName(from: date))
                           .font(.system(size: 14, weight: .medium))
                           .foregroundColor(textColor)
                       Spacer()
                   }
                   .frame(width: 46, height: 103)
                   .background(
                       Capsule().fill(color).opacity(0.7)
                   )
                   .overlay(
                       ZStack {
                           Circle()
                               .fill(Color.white)
                               .frame(width: 37)
                           if let day,
                              let url = vm.moodIconURL(for: day) {
                               AsyncImage(url: url) { image in
                                   image.resizable()
                                       .scaledToFit()
                                       .frame(width: 38)
                               } placeholder: {
                                   ProgressView()
                               }
                           }
                       }
                       .offset(y: 30)
                   )
               }
           }
           .frame(maxWidth: .infinity)
           .contentShape(Rectangle()) 
           .onTapGesture {
               withAnimation(.easeInOut) {
                   appState.selectedTab = 2 
               }
           }
           .task(id: effectiveToken) {
               guard let token = effectiveToken?.trimmingCharacters(in: .whitespacesAndNewlines),
                     !token.isEmpty else {
                   print("No token available yet — skipping fetch")
                   return
               }

               print("Token found:", token.prefix(12))
               vm.authToken = token

               if let provided = moods {
                   vm.useMoods(provided)
               } else {
                   await moodVM.fetchMoods()
                   vm.useMoods(moodVM.moods)
               }

               await vm.fetchDays()
           }
       }

       // MARK: - Helpers
       private func currentWeekDates() -> [Date] {
           let cal = Calendar.current
           let today = Date()
           let weekStart = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
           return (0..<7).compactMap { cal.date(byAdding: .day, value: $0, to: weekStart) }
       }

       private func dayNumber(from date: Date) -> String {
           let f = DateFormatter()
           f.dateFormat = "d"
           return f.string(from: date)
       }

       private func dayName(from date: Date) -> String {
           let f = DateFormatter()
           f.locale = Locale(identifier: "fr_FR")
           f.dateFormat = "EEE"
           return f.string(from: date).capitalized
       }
   }

#Preview {
    DayStreakView(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VySUQiOiI2QTIyQjEyRC05MTE2LTQ3OEYtQTU1Ni1FQzNCRUJCQjgxMkIiLCJzdWJqZWN0IjoiNkEyMkIxMkQtOTExNi00NzhGLUE1NTYtRUMzQkVCQkI4MTJCIiwiZXhwaXJhdGlvbiI6MTc2MTc0MjgwMS4wMzE5Nn0.UQP3ZRbtEKoYeG6bIB0vLN4MwtS9ALEQnxxl3x8f930")
        .environment(AppState())
}
