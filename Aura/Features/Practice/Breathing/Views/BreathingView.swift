//
//  BreathingView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 05/09/2025.
//

import SwiftUI

struct BreathingView: View {
    
    @State var viewModel = BreathingViewModel()
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack{
            VStack{
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(viewModel.breathings) { breathing in
                        NavigationLink {
                            BreathingPlayerView(viewModel:BreathingPlayerViewModel(duration: breathing.duration), animation: breathing.animation ?? .wave)
                        } label: {
                            ZStack(alignment: .bottomLeading) {
                                AsyncImage(url: URL(string: "http://192.168.1.128:8080/\(breathing.image)")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                    
                                } placeholder: {
                                    Text("Chargement...")
                                        .foregroundColor(.gray)
                                    
                                }
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(breathing.title)
                                        .font(.custom("Lexend-Medium", size: 20))
                                        .foregroundColor(.white)
                                    
                                    Text(breathing.description)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                                .padding(15)
                            }
                        }
                    }
                  
                }
                .padding(.horizontal)
            }
            .task {
                await viewModel.fetchBreathings() //charge les données du back
            }
        }
    }
}

#Preview {
    BreathingView()
}
