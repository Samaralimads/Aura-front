//
//  PickerView.swift
//  Aura
//
//  Created by alize suchon on 25/09/2025.
//

import SwiftUI

struct PickerView: View {
    
    @State var viewModel = PickerViewModel()
    var currentSelection = 0
    
    var body: some View {
        VStack (alignment: .leading){

            Text("Prêt(e) à commencer ?")
                .font(.custom("Lexend-Medium", size: 27))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 20)
                .padding(.top, 10)
                .padding(.horizontal, 17)

            Picker("", selection: $viewModel.selectedPratice) {
                Text("Méditation").tag(0)
                Text("Respiration").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.bottom,15)
            .padding(.horizontal, 17)

                if viewModel.selectedPratice == 0 {
                       MeditationView()
                   } else {
                       BreathingView()
                   }
        }
        .padding(.horizontal, 17)
        .onAppear {
            viewModel.selectedPratice = currentSelection
        }
    }
}

#Preview {
    PickerView()
}
