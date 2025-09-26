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
            
            Picker("", selection: $viewModel.selectedPratice) {
                ForEach(0..<viewModel.practices.count, id: \.self) { index in
                    Text(viewModel.practices[index]).tag(index)
                }
            }
            .pickerStyle(.segmented)
            
        }
        .padding(17)
        
        switch viewModel.selectedPratice {
        case 0:
            MeditationView()
        case 1:
            BreathingView()
        default:
            MeditationView()
        }
    }
}

#Preview {
    PickerView()
}
