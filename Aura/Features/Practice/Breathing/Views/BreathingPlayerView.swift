//
//  BreathingPlayerView.swift
//  Aura
//
//  Created by alize suchon on 26/09/2025.
//

import SwiftUI

struct BreathingPlayerView: View {
    
    @State var viewModel : BreathingPlayerViewModel
    @State private var timer : Int = 0
    
    public var body: some View {
        
        //MARK: - INTÉGRATION ANIMATIONS
        ZStack{
            if viewModel.indexOrder == 1 {
                WaveEffectView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            else if viewModel.indexOrder == 2 {
                MontainAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            else if viewModel.indexOrder == 3 {
                SunAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            else {
                MoonAnimationView(viewModel: viewModel)
                    .ignoresSafeArea()
            }
            
        //MARK: - GESTION PLAYER ET FIN DU CYCLE
            if !viewModel.isFinished {
                PlayerControllerView(viewModel: viewModel)
            } else {
                VStack(spacing: 10){
                    Text("Félicitations !")
                        .foregroundColor(.white)
                        .font(.custom("Lexend-Medium", size: 40))
                        .padding(.bottom, 10)
                    Text("Vous avez terminé votre séance \nde respiration.")
                        .foregroundColor(.white)
                        .font(.custom("Lexend-Regular", size: 20))
                        .multilineTextAlignment(.center)
                    
                    NavigationLink {
                         PickerView()
                    } label: {
                        Text("Valider")
                            .font(.custom("Lexend-medium", size: 17))
                            .foregroundStyle(.black)
                            .frame(width: 349, height: 48)
                            .cornerRadius(25)
                            .glassEffect(.regular.interactive())
                            .padding(.top, 40)
                    }
                    
                }
                .padding(.bottom, 150)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(17)
            }
        }
    }
}

#Preview {
    BreathingPlayerView(
        viewModel: BreathingPlayerViewModel(
            inhaleD: 2,
            holdD: 1,
            exhaleD: 2,
            nbOfCycles: 1,
            indexOrder : 3,
            audio: "night"
        )
    )
}
