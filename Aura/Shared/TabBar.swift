//
//  TabBar.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI
import Observation

struct TabBar: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        TabView(selection: Binding(
            get: { appState.selectedTab },
            set: { appState.selectedTab = $0 }
        )) {
            NavigationStack { DashboardView() }
                .tabItem { Image(appState.selectedTab == 0 ? "eye-light" : "eye-closed"); Text("Accueil") }
                .tag(0)

            NavigationStack { PickerView() }
                .tabItem { Image(appState.selectedTab == 1 ? "flower-lotus-fill" : "flower-lotus"); Text("Pratiques") }
                .tag(1)

            NavigationStack(path: Binding(
                get: { appState.humeurPath },
                set: { appState.humeurPath = $0 }
            )) {
                DayView(token: appState.token)

                    .navigationDestination(for: HumeurRoute.self) { route in
                        switch route {
                        case .mood:
                            MoodView()

                        case .configureDay(let moodID, let moodColorName):
                            DayConfigView(
                                moodID: moodID,
                                moodColorName: moodColorName,
                                token: appState.token
                            )
                        }
                    }
            }
            .tabItem { Image(appState.selectedTab == 2 ? "calendar-heart-fill" : "calendar-heart"); Text("Humeur") }
            .tag(2)

            NavigationStack {
                ProfileView(authState: appState)
            }
                .tabItem { Image(appState.selectedTab == 3 ? "user-fill" : "user"); Text("Profil") }
                .tag(3)
        }
        .tint(.black)
    }
}
#Preview {
    TabBar()
        .environment(AppState())
}
