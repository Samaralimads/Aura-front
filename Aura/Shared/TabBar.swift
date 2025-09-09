//
//  TabBar.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct TabBar: View {
    @State private var selection: Int = 0

    var body: some View {
        TabView(selection: $selection) {
            
            DashboardView()
                .tabItem {
                    Image(selection == 0 ? "eye-light" : "eye-closed")
                    Text("Accueil")
                }
                .tag(0)

            
           
            PracticeView()
                .tabItem {
                    Image(selection == 1 ? "flower-lotus-fill" : "flower-lotus")
                    Text("Pratiques")
                }
                .tag(1)

            MoodView()
                .tabItem {
                    Image(selection == 2 ? "calendar-heart-fill" : "calendar-heart")
                    Text("Humeur")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Image(selection == 3 ? "user-fill" : "user")
                    Text("Profil")
                }
                .tag(3)
        }
        .tint(.black)
    }
}


#Preview {
    TabBar()
}
