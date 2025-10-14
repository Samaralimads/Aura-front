//
//  DayConfigView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 01/10/2025.
//

import SwiftUI

struct DayConfigView: View {
    @State private var viewModel = DayConfigViewModel()
    
    @State private var selectedEmotionID: UUID?
    @State private var selectedReasonID: UUID?
    @State private var selectedSleepID: UUID?
    @State private var noteText: String = ""
    
    @State private var goToDay = false
    
    let moodID: UUID?
    let moodColorName: String?
    let token: String?
    
    init(moodID: UUID? = nil, moodColorName: String? = nil, token: String? = nil) {
        self.moodID = moodID
        self.moodColorName = moodColorName
        self.token = token
    }
    
    private var backgroundColor: Color {
        if let name = moodColorName { return Color(name) } else { return Color.gray }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .opacity(0.60)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Aujourd’hui")
                            .font(.custom("Lexend-medium", size: 27))
                            .foregroundStyle(.black)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                do {
                                    _ = try await viewModel.createDay(
                                        date: Date(),
                                        moodID: moodID,
                                        emotionID: nil,
                                        sleepID: nil,
                                        reasonID: nil,
                                        noteText: ""
                                    )
                                    goToDay = true
                                } catch {
                                    print("Skip-create failed:", error.localizedDescription)
                                }
                            }
                        } label: {
                            Text("skip >")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.bottom, 25)
                    
                    // MARK: - Émotions
                    Text("Émotions")
                        .font(.custom("Lexend-medium", size: 20))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 1)], spacing: 10) {
                        ForEach(viewModel.emotions(for: moodID), id: \.id) { emotion in
                            let isSelected = selectedEmotionID == emotion.id
                            Text(emotion.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.black)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 14)
                                .background(isSelected ? backgroundColor : Color.white)
                                .clipShape(Capsule())
                                .onTapGesture { selectedEmotionID = isSelected ? nil : emotion.id }
                                .animation(.easeInOut, value: isSelected)
                        }
                    }
                    
                    // MARK: - Raisons
                    Text("Raisons")
                        .font(.custom("Lexend-medium", size: 20))
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 10)], spacing: 20) {
                        ForEach(viewModel.displayReasons, id: \.id) { reason in
                            let isSelected = selectedReasonID == reason.id
                            
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected ? backgroundColor : Color.white)
                                        .frame(width: 63, height: 63)
                                    
                                    Image(reason.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                }
                                Text(reason.name)
                                    .font(.system(size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    .frame(maxWidth: .infinity)
                            }
                            .onTapGesture { selectedReasonID = isSelected ? nil : reason.id }
                            .animation(.easeInOut, value: isSelected)
                        }
                    }
                    
                    // MARK: - Sommeil
                    Text("Sommeil")
                        .font(.custom("Lexend-medium", size: 20))
                    
                    HStack(spacing: 16) {
                        ForEach(viewModel.displaySleeps, id: \.id) { sleep in
                            let isSelected = selectedSleepID == sleep.id
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected ? backgroundColor: Color.white)
                                        .frame(width: 63, height: 63)
                                    
                                    Image(sleep.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                }
                                Text(sleep.name)
                                    .font(.system(size: 14))
                            }
                            .frame(maxWidth: .infinity)
                            .onTapGesture { selectedSleepID = isSelected ? nil : sleep.id }
                            .animation(.easeInOut, value: isSelected)
                        }
                    }
                    
                    // MARK: - Note
                    Text("Journal")
                        .font(.custom("Lexend-medium", size: 20))

                    TextField("Ajouter une note", text: $noteText, axis: .vertical)
                        .lineLimit(20)
                        .padding(14)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    // MARK: - Valider
                    Button {
                        Task {
                            do {
                                _ = try await viewModel.createDay(
                                    date: Date(),
                                    moodID: moodID,
                                    emotionID: selectedEmotionID,
                                    sleepID: selectedSleepID,
                                    reasonID: selectedReasonID,
                                    noteText: noteText
                                )
                                goToDay = true
                            } catch {
                                print("Create day failed:", error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Valider")
                            .font(.custom("Lexend", size: 17))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity, minHeight: 52)
                            .background(backgroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }
                    .padding(.top, 8)
                }
                .padding(16)
            }
        }
        .navigationDestination(isPresented: $goToDay) {
            DayView(token: token)
        }
        .task {
            viewModel.authToken = token   
            await viewModel.fetchAll()
        }
    }
}

#Preview {
    DayConfigView(moodID: nil, moodColorName: nil)
}


