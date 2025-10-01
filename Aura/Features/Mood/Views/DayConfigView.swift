//
//  DayConfigView.swift
//  Aura
//
//  Created by Samara Lima da Silva on 01/10/2025.
//

import SwiftUI

struct DayConfigView: View {
    @State private var viewModel = MoodViewModel()

    
    var body: some View {
        ZStack{
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .task {
            await viewModel.fetchMoods()
        }
    }
}

#Preview {
    DayConfigView()
}
