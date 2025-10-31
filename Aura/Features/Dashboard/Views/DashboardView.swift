//
//  DashboardView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct DashboardView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(alignment: .leading, spacing: 14){
            Text("Salut \(appState.userName),")
                .font(.custom("Lexend-Medium", size: 27))
                .padding(.top, 70)
            
            
            ChallengeView()
            Text("Comment te sens-tu cette semaine ?")
                .font(.custom("Lexend-Regular", size: 17))
            DayStreakView()
            
            
            //MEDITATION
            HStack(alignment: .top){
                NavigationLink{
                    PickerView(currentSelection: 0)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 178, height: 230)
                            .cornerRadius(20)
                            .foregroundColor(.jauneClair)
                        VStack(spacing: 18){
                            VStack(spacing: 3){
                                Text("Meditation")
                                    .font(.custom("Lexend-Medium", size: 22))
                                    .foregroundColor(.black)
                                Text("Apaise ton esprit")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            Image("meditation")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 117)
                        }
                    }
                }
                
                //RESPIRATION
                NavigationLink{
                    PickerView(currentSelection: 1)
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(width: 178, height: 230)
                            .cornerRadius(20)
                            .foregroundColor(.vertClair)
                        VStack(spacing: 18){
                            VStack(spacing: 3){
                                Text("Respiration")
                                    .font(.custom("Lexend-Medium", size: 22))
                                    .foregroundColor(.black)
                                Text("Un souffle après l’autre")
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            Image("respiration")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 117)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    DashboardView()
        .environment(AppState())
}
