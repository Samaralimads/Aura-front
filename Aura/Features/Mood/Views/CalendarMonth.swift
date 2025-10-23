//
//  CalendarMonth.swift
//  Aura
//
//  Created by Samara Lima da Silva on 13/10/2025.
//

import SwiftUI

struct CalendarMonth: View {
    @Binding var month: Date
    
    var dayFor: (Date) -> DayModel?
    var moodIconURL: (DayModel) -> URL?
    var onSelect: (Date) -> Void = { _ in }
    var onAddTodayMood: () -> Void = {}
    
    @Environment(\.calendar) private var calendar
    @Environment(\.locale) private var locale
    
    private var daysGrid: [Date?] {
        let cal = calendar
        let startOfMonth = cal.date(from: cal.dateComponents([.year, .month], from: month))!
        let range = cal.range(of: .day, in: .month, for: startOfMonth)!
        let firstWeekdayIndex = cal.component(.weekday, from: startOfMonth) - cal.firstWeekday
        let leading = (firstWeekdayIndex + 7) % 7
        
        var result: [Date?] = Array(repeating: nil, count: leading)
        for day in range {
            result.append(cal.date(byAdding: .day, value: day - 1, to: startOfMonth)!)
        }
        return result
    }
    
    private var monthTitle: String {
        let f = DateFormatter()
        f.calendar = calendar
        f.locale = locale
        f.dateFormat = "LLLL yyyy"
        return f.string(from: month).capitalized
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            //MARK: - Header
            HStack {
                Text(monthTitle)
                    .font(.system(size: 17, weight: .semibold))
                Spacer()
                Button { shiftMonth(-1) } label: {
                    Image(systemName: "chevron.left").font(.headline)
                }
                Button { shiftMonth(+1) } label: {
                    Image(systemName: "chevron.right").font(.headline)
                }
            }
            .foregroundStyle(.black)
            
            //MARK: - Weekday row
            HStack {
                ForEach(weekdaySymbols(), id: \.self) { s in
                    Text(s).font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //MARK: -  Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 12) {
                ForEach(daysGrid.indices, id: \.self) { i in
                    if let date = daysGrid[i] {
                        DayCell(
                            date: date,
                            day: dayFor(date),
                            moodIconURL: { d in moodIconURL(d) },
                            onSelect: { onSelect(date) },
                            onAddTodayMood: onAddTodayMood
                        )
                        .frame(height: 36)
                    } else {
                        Color.clear.frame(height:36)
                    }
                }
            }
        }
    }
    
    private func shiftMonth(_ delta: Int) {
        if let new = calendar.date(byAdding: .month, value: delta, to: month) { month = new }
    }
    
    private func weekdaySymbols() -> [String] {
        let sym = calendar.shortWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return Array(sym[start...] + sym[..<start]).map { $0.uppercased() }
    }
}

private struct DayCell: View {
    let date: Date
    let day: DayModel?
    let moodIconURL: (DayModel) -> URL?
    
    let onSelect: () -> Void
    let onAddTodayMood: () -> Void
    
    @Environment(\.calendar) private var calendar
    
    private var isToday: Bool { calendar.isDateInToday(date) }
    private var isPast: Bool {
        calendar.startOfDay(for: date) < calendar.startOfDay(for: Date())
    }
    private var hasMood: Bool {
        guard let d = day else { return false }
        return !d.mood.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        Group {
            if hasMood, let d = day, let url = moodIconURL(d) {
                Button(action: onSelect) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let img):
                            img
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        default:
                            ProgressView()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .buttonStyle(.plain)
            } else if isToday {
                Button(action: onAddTodayMood) {
                    ZStack {
                        Circle().strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4,4]))
                        Text("+").font(.system(size: 18, weight: .bold))
                    }
                }
                .buttonStyle(.plain)
            } else {
                Button(action: onSelect) {
                    ZStack {
                        if isPast {
                            Circle().strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4,4]))
                        }
                        Text(String(calendar.component(.day, from: date)))
                            .font(.system(size: 16))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
    }
}
