//
//  PickerView.swift
//  Aura
//
//  Created by alize suchon on 25/09/2025.
//

import SwiftUI

struct PickerView: View {
    
    @State var viewModel = PickerViewModel()
    
    var body: some View {
        VStack (alignment: .leading){

            Text("Prêt(e) à commencer ?")
                .font(.custom("Lexend-Medium", size: 27))
                .multilineTextAlignment(.leading)
                .padding(.bottom, 20)
                .padding(.top, 10)
            
            Picker("", selection: $viewModel.selectedPratice) {
                Text("Méditation").tag(0)
                Text("Respiration").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.bottom,15)
            
                if viewModel.selectedPratice == 0 {
                       MeditationView()
                   } else {
                       BreathingView()
                   }
        }
        .padding(.horizontal, 17)
    }
}

#Preview {
    PickerView()
}
