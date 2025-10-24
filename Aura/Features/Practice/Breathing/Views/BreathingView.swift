//
//  BreathingView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct BreathingView: View {
    
    @State var breathingviewModel = BreathingViewModel()
    @State var userBreathingModelView = UserBreathingViewModel()
    let authService = AuthService.shared
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 14) {
                ForEach(breathingviewModel.breathings) { breathing in
                    NavigationLink {
                        BreathingPlayerView(viewModel:BreathingPlayerViewModel(
                            inhaleD: breathing.inhaleD,
                            holdD: breathing.holdD,
                            exhaleD: breathing.exhaleD,
                            nbOfCycles: breathing.nbOfCycles,
                            indexOrder: breathing.indexOrder,
                            audio : breathing.audio ?? ""
                        ))
                        .onAppear {
                            Task {
                                do {
                                    let userID = try await authService.getUserID()
                                    if let uuid = UUID(uuidString: userID) {
                                        await userBreathingModelView.sendUserBreathing(
                                            userID: uuid,
                                            breathingID: breathing.id
                                        )
                                    } else {
                                        print("ID utilisateur invalide: (userID)")
                                    }
                                } catch {
                                    print("Erreur lors de la récupération de l'ID utilisateur: (error)")
                                }
                            }
                        }
                    } label: {
                        ZStack(alignment: .bottomLeading) {
                            AsyncImage(url: URL(string: "http://127.0.0.1:8080/\(breathing.image)")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                
                            } placeholder: {
                                Text("chargement...")
                                    .foregroundColor(.gray)
                                ProgressView()
                                    .frame(height: 420)
                                    .padding(.leading,45)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(breathing.title)
                                    .font(.custom("Lexend-Medium", size: 20))
                                    .foregroundColor(.white)
                                
                                Text(breathing.description)
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                            }
                            .multilineTextAlignment(.leading)
                            .padding(15)
                        }
                    }
                }
            }
            .task {
                await breathingviewModel.fetchBreathings() //charge les données du back
            }
        }
    }
}

#Preview {
    BreathingView()
}
